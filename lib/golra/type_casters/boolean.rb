# frozen_string_literal: true

module Golra
  module TypeCasters
    class Boolean < Base
      TRUE_VALUES = [true, 1, "1", "true", "TRUE", "t", "T"].freeze
      FALSE_VALUES = [false, 0, "0", "false", "FALSE", "f", "F"].freeze

      class << self
        def cast!(value)
          return if value.nil?
          return true if TRUE_VALUES.include?(value)
          return false if FALSE_VALUES.include?(value)

          raise CastError.new(value, :boolean)
        end
      end
    end
  end
end
