# frozen_string_literal: true

module Golra
  module Predicates
    class NotIn < Base
      class << self
        def apply(scope, attribute, value)
          scope.where.not(attribute => Array(value))
        end
      end
    end
  end
end
