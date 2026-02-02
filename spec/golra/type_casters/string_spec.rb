# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::String) do
  describe ".cast!" do
    it "converts integer to string" do
      expect(described_class.cast!(123)).to(eq("123"))
    end

    it "converts float to string" do
      expect(described_class.cast!(12.34)).to(eq("12.34"))
    end

    it "keeps string as string" do
      expect(described_class.cast!("hello")).to(eq("hello"))
    end

    it "converts symbol to string" do
      expect(described_class.cast!(:hello)).to(eq("hello"))
    end

    it "handles nil" do
      expect(described_class.cast!(nil)).to(be_nil)
    end

    it "handles empty string" do
      expect(described_class.cast!("")).to(eq(""))
    end
  end
end
