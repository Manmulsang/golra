# frozen_string_literal: true

module Golra
  module TypeCasters
    class Base
      class << self
        def cast!(value)
          value
        end
      end
    end
  end
end
