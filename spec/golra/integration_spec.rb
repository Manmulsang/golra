# frozen_string_literal: true

require "spec_helper"
require "support/mock_models"

# Define mock models
class User < MockModel
  self.mock_columns = {
    "id" => MockColumn.new(type: :integer),
    "name" => MockColumn.new(type: :string),
    "email" => MockColumn.new(type: :string),
    "age" => MockColumn.new(type: :integer),
    "active" => MockColumn.new(type: :boolean),
    "created_at" => MockColumn.new(type: :datetime),
    "status" => MockColumn.new(type: :integer),
  }
  self.mock_table_name = "users"
  self.mock_enums = { "status" => { "active" => 0, "inactive" => 1, "banned" => 2 } }
end

class Post < MockModel
  self.mock_columns = {
    "id" => MockColumn.new(type: :integer),
    "title" => MockColumn.new(type: :string),
    "body" => MockColumn.new(type: :string),
    "published" => MockColumn.new(type: :boolean),
  }
  self.mock_table_name = "posts"
end

# Define Golra filters
class PostGolra < Golra::Base
  permit :title, :body, :published
end

class UserGolra < Golra::Base
  permit :name, :email, :age, :active, :created_at, :status
  association :posts, PostGolra
end

RSpec.describe("Golra Integration") do
  let(:scope) { MockScope.new(User) }

  describe "simple filters" do
    it "applies eq filter" do
      result = UserGolra.apply(scope, name__eq: "Kim")

      expect(result.where_calls).to(include(name: "Kim"))
    end

    it "applies cont filter" do
      result = UserGolra.apply(scope, name__cont: "im")

      expect(result.where_calls.any? { |c| c.is_a?(String) && c.include?("LIKE") }).to(be(true))
    end

    it "applies multiple filters" do
      result = UserGolra.apply(scope, name__eq: "Kim", age__gteq: 20)

      expect(result.where_calls).to(include(name: "Kim"))
      expect(result.where_calls.any? { |c| c.is_a?(String) && c.include?(">=") }).to(be(true))
    end

    it "raises error for non-permitted attributes" do
      expect do
        UserGolra.apply(scope, password__eq: "secret")
      end.to(raise_error(Golra::UnpermittedAttributeError))
    end

    it "raises error for invalid predicates" do
      expect do
        UserGolra.apply(scope, name__invalid: "test")
      end.to(raise_error(Golra::InvalidFilterKeyError))
    end
  end

  describe "type casting" do
    it "casts string to integer for age" do
      result = UserGolra.apply(scope, age__eq: "25")

      expect(result.where_calls).to(include(age: 25))
    end

    it "casts string to boolean for active" do
      result = UserGolra.apply(scope, active__eq: "true")

      expect(result.where_calls).to(include(active: true))
    end
  end

  describe "sorting" do
    it "applies single sort" do
      result = UserGolra.apply(scope, sort: "name__asc")

      expect(result.order_calls).to(include(name: :asc))
    end

    it "applies multiple sorts" do
      result = UserGolra.apply(scope, sort: ["created_at__desc", "name__asc"])

      expect(result.order_calls).to(include(created_at: :desc))
      expect(result.order_calls).to(include(name: :asc))
    end

    it "raises error for invalid sort direction" do
      expect do
        UserGolra.apply(scope, sort: "name__invalid")
      end.to(raise_error(Golra::InvalidSortError))
    end

    it "raises error for non-permitted sort attribute" do
      expect do
        UserGolra.apply(scope, sort: "password__asc")
      end.to(raise_error(Golra::UnpermittedAttributeError))
    end
  end

  describe "association filters" do
    it "applies join filter" do
      result = UserGolra.apply(scope, "posts::title__cont" => "Ruby")

      expect(result.joins_values).to(include(:posts))
      expect(result.where_calls.any? { |c| c.is_a?(String) && c.include?("LIKE") }).to(be(true))
    end

    it "raises error for non-declared associations" do
      expect do
        UserGolra.apply(scope, "comments::body__cont" => "test")
      end.to(raise_error(Golra::AssociationNotFoundError))
    end
  end

  describe "custom filters" do
    before do
      UserGolra.define_singleton_method(:name_or_email__cont) do |scope, value|
        scope.where("name LIKE '%#{value}%' OR email LIKE '%#{value}%'")
      end
    end

    after do
      UserGolra.singleton_class.remove_method(:name_or_email__cont)
    end

    it "calls custom filter method" do
      result = UserGolra.apply(scope, "name_or_email__cont" => "test")

      expect(result.where_calls.first).to(include("test"))
    end
  end

  describe "model inference" do
    it "infers model class from filter class name" do
      expect(UserGolra.model_class).to(eq(User))
    end

    it "infers model class for PostGolra" do
      expect(PostGolra.model_class).to(eq(Post))
    end
  end

  describe "null/not_null predicates" do
    it "applies null filter" do
      result = UserGolra.apply(scope, email__null: true)

      expect(result.where_calls).to(include(email: nil))
    end

    it "applies not_null filter" do
      result = UserGolra.apply(scope, email__not_null: true)

      expect(result.where_calls).to(include({ not: { email: nil } }))
    end
  end

  describe "enum filters" do
    it "applies eq filter with string value without casting" do
      result = UserGolra.apply(scope, status__eq: "active")

      expect(result.where_calls).to(include(status: "active"))
    end

    it "applies in filter with string values without casting" do
      result = UserGolra.apply(scope, status__in: ["active", "inactive"])

      expect(result.where_calls).to(include(status: ["active", "inactive"]))
    end

    it "applies not_eq filter" do
      result = UserGolra.apply(scope, status__not_eq: "banned")

      expect(result.where_calls).to(include({ not: { status: "banned" } }))
    end

    it "applies null filter" do
      result = UserGolra.apply(scope, status__null: true)

      expect(result.where_calls).to(include(status: nil))
    end

    it "does not raise CastError for non-integer string values" do
      expect do
        UserGolra.apply(scope, status__eq: "active")
      end.not_to(raise_error)
    end
  end

  describe "in/not_in predicates" do
    it "applies in filter" do
      result = UserGolra.apply(scope, age__in: [20, 25, 30])

      expect(result.where_calls).to(include(age: [20, 25, 30]))
    end

    it "applies not_in filter" do
      result = UserGolra.apply(scope, age__not_in: [20, 25, 30])

      expect(result.where_calls).to(include({ not: { age: [20, 25, 30] } }))
    end
  end
end
