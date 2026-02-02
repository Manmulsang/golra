# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "active_record"

require_relative "golra/version"
require_relative "golra/errors"

# Type Casters
require_relative "golra/type_casters/base"
require_relative "golra/type_casters/string"
require_relative "golra/type_casters/integer"
require_relative "golra/type_casters/float"
require_relative "golra/type_casters/decimal"
require_relative "golra/type_casters/boolean"
require_relative "golra/type_casters/datetime"
require_relative "golra/type_casters/date"
require_relative "golra/type_caster_registry"

# Predicates
require_relative "golra/predicates/base"
require_relative "golra/predicates/eq"
require_relative "golra/predicates/not_eq"
require_relative "golra/predicates/cont"
require_relative "golra/predicates/start_with"
require_relative "golra/predicates/end_with"
require_relative "golra/predicates/gt"
require_relative "golra/predicates/gteq"
require_relative "golra/predicates/lt"
require_relative "golra/predicates/lteq"
require_relative "golra/predicates/in"
require_relative "golra/predicates/not_in"
require_relative "golra/predicates/null"
require_relative "golra/predicates/not_null"
require_relative "golra/predicate_registry"

# Core
require_relative "golra/base"

module Golra
end
