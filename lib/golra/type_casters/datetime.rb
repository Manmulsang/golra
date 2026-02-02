# frozen_string_literal: true

module Golra
  module TypeCasters
    class Datetime < Base
      class << self
        def cast!(value)
          case value
          when nil then nil
          when ::ActiveSupport::TimeWithZone, ::Time then value
          when ::DateTime then value.to_time
          when ::Integer, ::Float, ::BigDecimal then ::Time.at(value)
          when ::String
            parse_string(value)
          else
            raise CastError.new(value, :datetime)
          end
        end

        private

        def parse_string(value)
          if ::Time.zone
            ::Time.zone.parse(value) || raise(CastError.new(value, :datetime))
          else
            ::Time.parse(value)
          end
        rescue ArgumentError
          raise CastError.new(value, :datetime)
        end
      end
    end
  end
end
