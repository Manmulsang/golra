# frozen_string_literal: true

module Golra
  module TypeCasterRegistry
    CASTERS = {
      string: TypeCasters::String,
      integer: TypeCasters::Integer,
      float: TypeCasters::Float,
      decimal: TypeCasters::Decimal,
      boolean: TypeCasters::Boolean,
      datetime: TypeCasters::Datetime,
      date: TypeCasters::Date,
    }.freeze

    extend self

    def registered?(type)
      CASTERS.key?(type.to_sym)
    end

    def available_types
      CASTERS.keys
    end

    def find(type)
      CASTERS[type.to_sym] || raise(TypeCasterNotFoundError.new(type, available_types))
    end

    def cast!(type, value, attribute: nil)
      find(type).cast!(value)
    rescue CastError => e
      raise CastError.new(e.value, e.target_type, attribute: attribute)
    end
  end
end
