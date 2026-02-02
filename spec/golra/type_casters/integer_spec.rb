# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::Integer) do
  describe ".cast!" do
    it "converts string to integer" do
      expect(described_class.cast!("123")).to(eq(123))
    end

    it "converts float to integer" do
      expect(described_class.cast!(12.7)).to(eq(12))
    end

    it "keeps integer as integer" do
      expect(described_class.cast!(42)).to(eq(42))
    end

    it "handles negative numbers" do
      expect(described_class.cast!("-99")).to(eq(-99))
    end

    it "handles nil" do
      expect(described_class.cast!(nil)).to(be_nil)
    end

    it "raises CastError for invalid value" do
      expect { described_class.cast!("abc") }.to(raise_error(Golra::CastError))
    end

    it "raises CastError for empty string" do
      expect { described_class.cast!("") }.to(raise_error(Golra::CastError))
    end
  end
end
