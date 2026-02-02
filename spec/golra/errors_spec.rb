# frozen_string_literal: true

require "spec_helper"

RSpec.describe("Golra Errors") do
  describe Golra::CastError do
    it "includes value and type in message" do
      error = described_class.new("abc", :integer)
      expect(error.message).to(include("abc"))
      expect(error.message).to(include("integer"))
      expect(error.value).to(eq("abc"))
      expect(error.target_type).to(eq(:integer))
    end

    it "includes attribute when provided" do
      error = described_class.new("abc", :integer, attribute: :age)
      expect(error.message).to(include("age"))
      expect(error.attribute).to(eq(:age))
    end
  end

  describe Golra::ModelNotFoundError do
    it "includes golra class and model name" do
      error = described_class.new("UserGolra", "User")
      expect(error.message).to(include("User"))
      expect(error.message).to(include("UserGolra"))
      expect(error.golra_class).to(eq("UserGolra"))
      expect(error.model_name).to(eq("User"))
    end
  end

  describe Golra::UnpermittedAttributeError do
    it "includes attribute and permitted list" do
      error = described_class.new(:password, "UserGolra", Set.new([:name, :email]))
      expect(error.message).to(include("password"))
      expect(error.message).to(include("UserGolra"))
      expect(error.message).to(include("name"))
      expect(error.message).to(include("email"))
    end
  end

  describe Golra::AttributeNotFoundError do
    it "includes attribute and model class" do
      error = described_class.new(:foo, "User")
      expect(error.message).to(include("foo"))
      expect(error.message).to(include("User"))
    end
  end

  describe Golra::InvalidPredicateError do
    it "includes predicate name" do
      error = described_class.new(:invalid)
      expect(error.message).to(include("invalid"))
    end

    it "includes available predicates when provided" do
      error = described_class.new(:invalid, [:eq, :cont, :gt])
      expect(error.message).to(include("eq"))
      expect(error.message).to(include("cont"))
      expect(error.message).to(include("gt"))
    end
  end

  describe Golra::UnsupportedPredicateError do
    it "includes predicate and type" do
      error = described_class.new(:cont, :integer)
      expect(error.message).to(include("cont"))
      expect(error.message).to(include("integer"))
    end

    it "includes attribute when provided" do
      error = described_class.new(:cont, :integer, attribute: :age)
      expect(error.message).to(include("age"))
    end

    it "includes supported types when provided" do
      error = described_class.new(:cont, :integer, supported_types: [:string])
      expect(error.message).to(include("string"))
    end
  end

  describe Golra::AssociationNotFoundError do
    it "includes association name and golra class" do
      error = described_class.new(:posts, "UserGolra")
      expect(error.message).to(include("posts"))
      expect(error.message).to(include("UserGolra"))
    end

    it "includes available associations when provided" do
      error = described_class.new(:posts, "UserGolra", [:comments, :tags])
      expect(error.message).to(include("comments"))
      expect(error.message).to(include("tags"))
    end
  end

  describe Golra::InvalidSortError do
    it "includes sort value" do
      error = described_class.new("invalid_sort")
      expect(error.message).to(include("invalid_sort"))
    end

    it "includes reason when provided" do
      error = described_class.new("name", "missing direction")
      expect(error.message).to(include("missing direction"))
    end

    it "includes expected format" do
      error = described_class.new("bad")
      expect(error.message).to(include("attribute__direction"))
    end
  end

  describe Golra::TypeCasterNotFoundError do
    it "includes type" do
      error = described_class.new(:unknown)
      expect(error.message).to(include("unknown"))
    end

    it "includes available types when provided" do
      error = described_class.new(:unknown, [:string, :integer])
      expect(error.message).to(include("string"))
      expect(error.message).to(include("integer"))
    end
  end

  describe Golra::InvalidFilterKeyError do
    it "includes key" do
      error = described_class.new("bad_key")
      expect(error.message).to(include("bad_key"))
    end

    it "includes reason when provided" do
      error = described_class.new("bad", "no predicate")
      expect(error.message).to(include("no predicate"))
    end

    it "includes expected format" do
      error = described_class.new("bad")
      expect(error.message).to(include("attribute__predicate"))
    end
  end
end
