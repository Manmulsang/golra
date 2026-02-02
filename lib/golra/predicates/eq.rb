# frozen_string_literal: true

module Golra
  module Predicates
    class Eq < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(attribute => value)
        end
      end
    end
  end
end
