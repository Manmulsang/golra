# frozen_string_literal: true

module Golra
  module Predicates
    class Null < Base
      class << self
        def apply(scope, attribute, value)
          if value
            scope.where(attribute => nil)
          else
            scope.where.not(attribute => nil)
          end
        end
      end
    end
  end
end
