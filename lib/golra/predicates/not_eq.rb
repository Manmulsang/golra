# frozen_string_literal: true

module Golra
  module Predicates
    class NotEq < Base
      class << self
        def apply(scope, attribute, value)
          scope.where.not(attribute => value)
        end
      end
    end
  end
end
