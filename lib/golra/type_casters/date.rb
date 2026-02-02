# frozen_string_literal: true

module Golra
  module TypeCasters
    class Date < Base
      class << self
        def cast!(value)
          case value
          when nil then nil
          when ::Date then value
          when ::Time, ::DateTime, ::ActiveSupport::TimeWithZone then value.to_date
          when ::Integer, ::Float, ::BigDecimal then ::Time.zone.at(value).to_date
          when ::String
            begin
              ::Date.parse(value)
            rescue ArgumentError
              raise CastError.new(value, :date)
            end
          else
            raise CastError.new(value, :date)
          end
        end
      end
    end
  end
end
