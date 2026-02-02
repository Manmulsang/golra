# frozen_string_literal: true

module Golra
  module TypeCasters
    class Decimal < Base
      class << self
        def cast!(value)
          case value
          when nil then nil
          when ::BigDecimal then value
          when ::Integer, ::Float then BigDecimal(value.to_s)
          when ::String
            raise CastError.new(value, :decimal) unless value.match?(/\A-?\d+(\.\d+)?\z/)

            BigDecimal(value)
          else
            raise CastError.new(value, :decimal)
          end
        end
      end
    end
  end
end
