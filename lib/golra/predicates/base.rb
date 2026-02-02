# frozen_string_literal: true

module Golra
  module Predicates
    class Base
      class << self
        def apply(_scope, _attribute, _value)
          raise NotImplementedError, "Subclass must implement .apply"
        end

        def arel_attribute(scope, attribute)
          scope.klass.arel_table[attribute]
        end
      end
    end
  end
end
