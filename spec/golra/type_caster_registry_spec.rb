# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasterRegistry) do
  describe ".find" do
    it "returns caster for known type" do
      expect(described_class.find(:integer)).to(eq(Golra::TypeCasters::Integer))
    end

    it "raises error for unknown type" do
      expect { described_class.find(:unknown) }.to(raise_error(Golra::Error))
    end
  end

  describe ".cast!" do
    it "casts value using correct caster" do
      expect(described_class.cast!(:integer, "123")).to(eq(123))
    end
  end
end
