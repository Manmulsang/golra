# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::Decimal) do
  describe ".cast!" do
    it "converts string to BigDecimal" do
      result = described_class.cast!("12.34")
      expect(result).to(be_a(BigDecimal))
      expect(result).to(eq(BigDecimal("12.34")))
    end

    it "converts integer to BigDecimal" do
      result = described_class.cast!(42)
      expect(result).to(be_a(BigDecimal))
      expect(result).to(eq(BigDecimal("42")))
    end

    it "converts float to BigDecimal" do
      result = described_class.cast!(3.14)
      expect(result).to(be_a(BigDecimal))
    end

    it "keeps BigDecimal as BigDecimal" do
      value = BigDecimal("99.99")
      expect(described_class.cast!(value)).to(eq(value))
    end

    it "handles negative numbers" do
      result = described_class.cast!("-99.5")
      expect(result).to(eq(BigDecimal("-99.5")))
    end

    it "handles nil" do
      expect(described_class.cast!(nil)).to(be_nil)
    end

    it "raises CastError for invalid value" do
      expect { described_class.cast!("abc") }.to(raise_error(Golra::CastError))
    end
  end
end
