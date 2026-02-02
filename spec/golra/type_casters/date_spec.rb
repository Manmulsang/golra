# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::Date) do
  describe ".cast!" do
    it "parses date string" do
      result = described_class.cast!("2024-01-15")
      expect(result).to(be_a(Date))
      expect(result.year).to(eq(2024))
      expect(result.month).to(eq(1))
      expect(result.day).to(eq(15))
    end

    it "parses date with slashes" do
      result = described_class.cast!("2024/01/15")
      expect(result).to(be_a(Date))
      expect(result.year).to(eq(2024))
    end

    it "keeps Date as Date" do
      value = Date.new(2024, 1, 15)
      expect(described_class.cast!(value)).to(eq(value))
    end

    it "converts DateTime to Date" do
      datetime = Time.new(2024, 1, 15, 10, 30, 0)
      result = described_class.cast!(datetime)
      expect(result).to(be_a(Date))
      expect(result.day).to(eq(15))
    end

    it "handles nil" do
      expect(described_class.cast!(nil)).to(be_nil)
    end

    it "raises CastError for invalid value" do
      expect { described_class.cast!("not a date") }.to(raise_error(Golra::CastError))
    end
  end
end
