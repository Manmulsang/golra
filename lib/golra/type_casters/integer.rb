# frozen_string_literal: true

module Golra
  module TypeCasters
    class Integer < Base
      class << self
        def cast!(value)
          case value
          when nil then nil
          when ::Integer then value
          when ::Float, ::BigDecimal then value.to_i
          when ::String
            raise CastError.new(value, :integer) unless value.match?(/\A-?\d+(\.\d+)?\z/)

            value.to_i
          else
            raise CastError.new(value, :integer)
          end
        end
      end
    end
  end
end
