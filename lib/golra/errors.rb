# frozen_string_literal: true

module Golra
  # Base error class for all Golra errors
  class Error < StandardError; end

  # Raised when type casting fails
  class CastError < Error
    attr_reader :value, :target_type, :attribute

    def initialize(value, target_type, attribute: nil)
      @value = value
      @target_type = target_type
      @attribute = attribute

      message = "Cannot cast #{value.inspect} to #{target_type}"
      message += " for attribute '#{attribute}'" if attribute
      super(message)
    end
  end

  # Raised when model class cannot be inferred from Golra class name
  class ModelNotFoundError < Error
    attr_reader :golra_class, :model_name

    def initialize(golra_class, model_name)
      @golra_class = golra_class
      @model_name = model_name
      super("Cannot find model '#{model_name}' for #{golra_class}. " \
        "Expected class name format: '<ModelName>Golra'")
    end
  end

  # Raised when attribute is not permitted
  class UnpermittedAttributeError < Error
    attr_reader :attribute, :golra_class, :permitted_attributes

    def initialize(attribute, golra_class, permitted_attributes)
      @attribute = attribute
      @golra_class = golra_class
      @permitted_attributes = permitted_attributes

      super("Attribute '#{attribute}' is not permitted in #{golra_class}. " \
        "Permitted attributes: #{permitted_attributes.to_a.join(", ")}")
    end
  end

  # Raised when attribute does not exist in the model
  class AttributeNotFoundError < Error
    attr_reader :attribute, :model_class

    def initialize(attribute, model_class)
      @attribute = attribute
      @model_class = model_class
      super("Attribute '#{attribute}' does not exist in #{model_class}")
    end
  end

  # Raised when predicate is invalid
  class InvalidPredicateError < Error
    attr_reader :predicate, :available_predicates

    def initialize(predicate, available_predicates = nil)
      @predicate = predicate
      @available_predicates = available_predicates

      message = "Invalid predicate '#{predicate}'"
      message += ". Available: #{available_predicates.join(", ")}" if available_predicates
      super(message)
    end
  end

  # Raised when predicate does not support the column type
  class UnsupportedPredicateError < Error
    attr_reader :predicate, :column_type, :attribute, :supported_types

    def initialize(predicate, column_type, attribute: nil, supported_types: nil)
      @predicate = predicate
      @column_type = column_type
      @attribute = attribute
      @supported_types = supported_types

      message = "Predicate '#{predicate}' does not support type '#{column_type}'"
      message += " for attribute '#{attribute}'" if attribute
      message += ". Supported types: #{supported_types.join(", ")}" if supported_types
      super(message)
    end
  end

  # Raised when association is not declared
  class AssociationNotFoundError < Error
    attr_reader :association_name, :golra_class, :available_associations

    def initialize(association_name, golra_class, available_associations = nil)
      @association_name = association_name
      @golra_class = golra_class
      @available_associations = available_associations

      message = "Association '#{association_name}' is not declared in #{golra_class}"
      message += ". Available: #{available_associations.join(", ")}" if available_associations&.any?
      super(message)
    end
  end

  # Raised when sort format is invalid
  class InvalidSortError < Error
    attr_reader :sort_value, :expected_format

    def initialize(sort_value, reason = nil)
      @sort_value = sort_value
      @expected_format = "attribute__direction (e.g., 'name__asc', 'created_at__desc')"

      message = "Invalid sort '#{sort_value}'"
      message += ": #{reason}" if reason
      message += ". Expected format: #{@expected_format}"
      super(message)
    end
  end

  # Raised when type caster is not found
  class TypeCasterNotFoundError < Error
    attr_reader :type, :available_types

    def initialize(type, available_types = nil)
      @type = type
      @available_types = available_types

      message = "No type caster found for type '#{type}'"
      message += ". Available types: #{available_types.join(", ")}" if available_types
      super(message)
    end
  end

  # Raised when filter key format is invalid
  class InvalidFilterKeyError < Error
    attr_reader :key, :expected_format

    def initialize(key, reason = nil)
      @key = key
      @expected_format = "attribute__predicate (e.g., 'name__eq', 'age__gteq')"

      message = "Invalid filter key '#{key}'"
      message += ": #{reason}" if reason
      message += ". Expected format: #{@expected_format}"
      super(message)
    end
  end
end
