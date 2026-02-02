# frozen_string_literal: true

module Golra
  module Predicates
    class Lt < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(arel_attribute(scope, attribute).lt(value))
        end
      end
    end
  end
end
