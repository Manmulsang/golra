# frozen_string_literal: true

module Golra
  class Base
    class << self
      attr_accessor :permitted_attributes, :associations

      def inherited(subclass)
        super
        subclass.permitted_attributes = Set.new
        subclass.associations = {}
      end

      def model_class
        @model_class ||= infer_model_class
      end

      def permit(*attributes)
        attributes.each { |attribute| permitted_attributes.add(attribute.to_sym) }
      end

      def association(name, golra_class)
        associations[name.to_sym] = golra_class
      end

      def apply(scope, params = {})
        params = params.dup
        sort_value = params.delete(:sort) || params.delete("sort")

        params.each do |key, value|
          scope = apply_filter(scope, key.to_s, value)
        end

        scope = apply_sort(scope, sort_value) if sort_value
        scope
      end

      private

      def infer_model_class
        model_name = name.demodulize.delete_suffix("Golra")
        model_name.constantize
      rescue NameError
        raise ModelNotFoundError.new(name, model_name)
      end

      def apply_filter(scope, key, value)
        return public_send(key, scope, value) if respond_to?(key)

        if key.include?("::")
          apply_join_filter(scope, key, value)
        else
          apply_simple_filter(scope, key, value)
        end
      end

      def apply_simple_filter(scope, key, value)
        attribute, predicate = parse_key(key)
        raise InvalidFilterKeyError, key unless attribute && predicate

        unless permitted_attributes.include?(attribute)
          raise UnpermittedAttributeError.new(
            attribute,
            self,
            permitted_attributes,
          )
        end

        type = column_type(model_class, attribute)
        raise AttributeNotFoundError.new(attribute, model_class) unless type

        unless PredicateRegistry.supports?(
          predicate, type
        )
          raise UnsupportedPredicateError.new(
            predicate,
            type,
            attribute: attribute,
            supported_types: PredicateRegistry.supported_types(predicate),
          )
        end

        casted_value = cast_value(type, value, attribute: attribute)
        PredicateRegistry.find_class(predicate).apply(scope, attribute, casted_value)
      end

      def apply_join_filter(scope, key, value)
        join_context = build_join_context(key)

        raise InvalidFilterKeyError.new(key, "invalid join key format") unless join_context[:association]

        unless join_context[:golra]
          raise AssociationNotFoundError.new(
            join_context[:association],
            self,
            associations.keys,
          )
        end
        raise InvalidFilterKeyError, key unless join_context[:attribute] && join_context[:predicate]

        unless join_context[:golra].permitted_attributes.include?(join_context[:attribute])
          raise UnpermittedAttributeError.new(
            join_context[:attribute],
            join_context[:golra],
            join_context[:golra].permitted_attributes,
          )
        end

        type = column_type(join_context[:model], join_context[:attribute])
        raise AttributeNotFoundError.new(join_context[:attribute], join_context[:model]) unless type

        unless PredicateRegistry.supports?(
          join_context[:predicate], type
        )
          raise UnsupportedPredicateError.new(
            join_context[:predicate],
            type,
            attribute: join_context[:attribute],
            supported_types: PredicateRegistry.supported_types(join_context[:predicate]),
          )
        end

        apply_join_predicate(scope, join_context, cast_value(type, value, attribute: join_context[:attribute]))
      end

      def build_join_context(key)
        association_name, attribute, predicate = parse_join_key(key)
        golra = associations[association_name]
        model = golra&.model_class

        { association: association_name, attribute: attribute, predicate: predicate, model: model, golra: golra }
      end

      def apply_join_predicate(scope, context, casted_value)
        scope = scope.joins(context[:association]) unless scope.joins_values.include?(context[:association])
        qualified_attribute = "#{context[:model].table_name}.#{context[:attribute]}"
        PredicateRegistry.find_class(context[:predicate]).apply(scope, qualified_attribute, casted_value)
      end

      def apply_sort(scope, sort_values)
        Array(sort_values).each do |sort|
          attribute, direction = parse_sort(sort)

          raise InvalidSortError, sort unless attribute && direction

          unless permitted_attributes.include?(attribute)
            raise UnpermittedAttributeError.new(
              attribute,
              self,
              permitted_attributes,
            )
          end

          scope = scope.order(attribute => direction)
        end
        scope
      end

      def parse_sort(sort)
        parts = sort.to_s.split("__")
        return [nil, nil] unless parts.size == 2

        attribute = parts[0].to_sym
        direction = parts[1].to_sym
        return [nil, nil] unless [:asc, :desc].include?(direction)

        [attribute, direction]
      end

      def column_type(model, attribute)
        return :enum if model.respond_to?(:defined_enums) && model.defined_enums.key?(attribute.to_s)

        model.columns_hash[attribute.to_s]&.type
      end

      def cast_value(type, value, attribute: nil)
        return value if type == :enum

        case value
        when Array
          value.map { |v| TypeCasterRegistry.cast!(type, v, attribute: attribute) }
        else
          TypeCasterRegistry.cast!(type, value, attribute: attribute)
        end
      end

      def parse_key(key)
        parts = key.to_s.split("__")
        return [nil, nil] unless parts.size == 2

        attribute, predicate = parts
        predicate = predicate.to_sym
        return [nil, nil] unless PredicateRegistry.registered?(predicate)

        [attribute.to_sym, predicate]
      end

      def parse_join_key(key)
        parts = key.split("::")
        return [nil, nil, nil] unless parts.size == 2

        association_name = parts[0].to_sym
        attribute, predicate = parse_key(parts[1])

        [association_name, attribute, predicate]
      end
    end
  end
end
