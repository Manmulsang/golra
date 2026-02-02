# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::Datetime) do
  describe ".cast!" do
    it "parses ISO 8601 datetime string" do
      result = described_class.cast!("2024-01-15T10:30:00")
      expect(result).to(be_a(Time))
      expect(result.year).to(eq(2024))
      expect(result.month).to(eq(1))
      expect(result.day).to(eq(15))
    end

    it "parses datetime with timezone" do
      result = described_class.cast!("2024-01-15T10:30:00+09:00")
      expect(result).to(be_a(Time))
      expect(result.year).to(eq(2024))
    end

    it "keeps Time as Time" do
      value = Time.new(2024, 1, 15, 10, 30, 0)
      result = described_class.cast!(value)
      expect(result).to(be_a(Time))
      expect(result).to(eq(value))
    end

    it "converts DateTime to Time" do
      datetime = Time.new(2024, 1, 15, 10, 30, 0)
      result = described_class.cast!(datetime)
      expect(result).to(be_a(Time))
      expect(result.year).to(eq(2024))
      expect(result.day).to(eq(15))
    end

    it "converts timestamp to Time" do
      timestamp = 1_705_312_200 # 2024-01-15 10:30:00 UTC
      result = described_class.cast!(timestamp)
      expect(result).to(be_a(Time))
    end

    it "handles nil" do
      expect(described_class.cast!(nil)).to(be_nil)
    end

    it "raises CastError for invalid value" do
      expect { described_class.cast!("not a date") }.to(raise_error(Golra::CastError))
    end
  end
end
