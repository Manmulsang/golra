# frozen_string_literal: true

module Golra
  module Predicates
    class NotNull < Base
      class << self
        def apply(scope, attribute, value)
          if value
            scope.where.not(attribute => nil)
          else
            scope.where(attribute => nil)
          end
        end
      end
    end
  end
end
