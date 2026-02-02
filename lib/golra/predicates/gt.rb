# frozen_string_literal: true

module Golra
  module Predicates
    class Gt < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(arel_attribute(scope, attribute).gt(value))
        end
      end
    end
  end
end
