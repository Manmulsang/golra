# frozen_string_literal: true

module Golra
  module PredicateRegistry
    PREDICATES = {
      eq: [:string, :integer, :float, :decimal, :datetime, :date, :boolean, :enum],
      not_eq: [:string, :integer, :float, :decimal, :datetime, :date, :boolean, :enum],
      cont: [:string],
      start_with: [:string],
      end_with: [:string],
      gt: [:integer, :float, :decimal, :datetime, :date],
      gteq: [:integer, :float, :decimal, :datetime, :date],
      lt: [:integer, :float, :decimal, :datetime, :date],
      lteq: [:integer, :float, :decimal, :datetime, :date],
      in: [:string, :integer, :float, :decimal, :datetime, :date, :boolean, :enum],
      not_in: [:string, :integer, :float, :decimal, :datetime, :date, :boolean, :enum],
      null: [:string, :integer, :float, :decimal, :datetime, :date, :boolean, :enum],
      not_null: [:string, :integer, :float, :decimal, :datetime, :date, :boolean, :enum],
    }.freeze

    extend self

    def all
      PREDICATES.keys
    end

    def registered?(predicate)
      PREDICATES.key?(predicate.to_sym)
    end

    def supports?(predicate, type)
      return false if type.nil?

      PREDICATES[predicate.to_sym]&.include?(type.to_sym) || false
    end

    def supported_types(predicate)
      PREDICATES[predicate.to_sym] || []
    end

    def find_class(name)
      Predicates.const_get(name.to_s.camelize)
    rescue NameError
      raise InvalidPredicateError.new(name, all)
    end

    def validate!(predicate, type, attribute: nil)
      raise InvalidPredicateError.new(predicate, all) unless registered?(predicate)

      return if supports?(predicate, type)

      raise UnsupportedPredicateError.new(
        predicate,
        type,
        attribute: attribute,
        supported_types: supported_types(predicate),
      )
    end
  end
end
