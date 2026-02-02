# frozen_string_literal: true

module Golra
  module TypeCasters
    class String < Base
      class << self
        def cast!(value)
          return if value.nil?

          value.to_s
        end
      end
    end
  end
end
