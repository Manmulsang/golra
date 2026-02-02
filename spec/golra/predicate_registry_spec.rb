# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::PredicateRegistry) do
  describe ".all" do
    it "returns all predicate names" do
      expect(described_class.all).to(include(:eq, :cont, :gt, :in, :null))
    end
  end

  describe ".supports?" do
    it "returns true for supported type" do
      expect(described_class.supports?(:cont, :string)).to(be(true))
    end

    it "returns false for unsupported type" do
      expect(described_class.supports?(:cont, :integer)).to(be(false))
    end
  end

  describe ".find_class" do
    it "returns predicate class" do
      expect(described_class.find_class(:eq)).to(eq(Golra::Predicates::Eq))
    end
  end
end
