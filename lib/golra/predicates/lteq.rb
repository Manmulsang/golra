# frozen_string_literal: true

module Golra
  module Predicates
    class Lteq < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(arel_attribute(scope, attribute).lteq(value))
        end
      end
    end
  end
end
