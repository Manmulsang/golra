# frozen_string_literal: true

module Golra
  module Predicates
    class In < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(attribute => Array(value))
        end
      end
    end
  end
end
