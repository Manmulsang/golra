# frozen_string_literal: true

module Golra
  module Predicates
    class Gteq < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(arel_attribute(scope, attribute).gteq(value))
        end
      end
    end
  end
end
