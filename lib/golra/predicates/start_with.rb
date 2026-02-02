# frozen_string_literal: true

module Golra
  module Predicates
    class StartWith < Base
      class << self
        def apply(scope, attribute, value)
          scope.where(arel_attribute(scope, attribute).matches("#{sanitize(value)}%"))
        end

        private

        def sanitize(value)
          value.to_s.gsub(/[%_]/) { |c| "\\#{c}" }
        end
      end
    end
  end
end
