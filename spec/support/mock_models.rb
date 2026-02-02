# frozen_string_literal: true

# Mock column for simulating ActiveRecord columns
MockColumn = Struct.new(:type, keyword_init: true)

# Mock ActiveRecord model for testing without database
class MockModel
  class << self
    attr_accessor :mock_columns, :mock_table_name, :mock_enums

    def columns_hash
      mock_columns || {}
    end

    def defined_enums
      mock_enums || {}
    end

    def table_name
      mock_table_name || name.downcase.pluralize
    end

    def arel_table
      @arel_table ||= MockArelTable.new(table_name)
    end

    def unscoped
      MockScope.new(self)
    end
  end
end

# Mock Arel table
class MockArelTable
  attr_reader :table_name

  def initialize(table_name)
    @table_name = table_name
  end

  def [](column)
    MockArelAttribute.new(table_name, column)
  end
end

# Mock Arel attribute
class MockArelAttribute
  attr_reader :table_name, :column_name

  def initialize(table_name, column_name)
    @table_name = table_name
    @column_name = column_name
  end

  def gt(value)
    "#{column_name} > #{value.inspect}"
  end

  def gteq(value)
    "#{column_name} >= #{value.inspect}"
  end

  def lt(value)
    "#{column_name} < #{value.inspect}"
  end

  def lteq(value)
    "#{column_name} <= #{value.inspect}"
  end

  def matches(value)
    "#{column_name} LIKE #{value.inspect}"
  end
end

# Mock scope for tracking method calls
class MockScope
  attr_reader :klass, :where_calls, :order_calls, :joins_values

  def initialize(klass)
    @klass = klass
    @where_calls = []
    @order_calls = []
    @joins_values = []
  end

  def where(condition = nil)
    if condition.nil?
      MockWhereChain.new(self)
    else
      @where_calls << condition
      self
    end
  end

  def order(condition)
    @order_calls << condition
    self
  end

  def joins(association)
    @joins_values << association
    self
  end

  def or(other_scope)
    @where_calls << { or: other_scope.where_calls }
    self
  end

  def merge(other_scope)
    @where_calls.concat(other_scope.where_calls)
    self
  end
end

# Mock where chain for .where.not()
class MockWhereChain
  def initialize(scope)
    @scope = scope
  end

  def not(condition)
    @scope.where_calls << { not: condition }
    @scope
  end
end
