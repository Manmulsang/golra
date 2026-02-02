# frozen_string_literal: true

module Golra
  module TypeCasters
    class Float < Base
      class << self
        def cast!(value)
          case value
          when nil then nil
          when ::Float then value
          when ::Integer, ::BigDecimal then value.to_f
          when ::String
            raise CastError.new(value, :float) unless value.match?(/\A-?\d+(\.\d+)?\z/)

            value.to_f
          else
            raise CastError.new(value, :float)
          end
        end
      end
    end
  end
end
