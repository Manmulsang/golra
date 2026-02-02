# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::Float) do
  describe ".cast!" do
    it "converts string to float" do
      expect(described_class.cast!("12.34")).to(eq(12.34))
    end

    it "converts integer to float" do
      expect(described_class.cast!(42)).to(eq(42.0))
    end

    it "keeps float as float" do
      expect(described_class.cast!(3.14)).to(eq(3.14))
    end

    it "handles negative numbers" do
      expect(described_class.cast!("-99.5")).to(eq(-99.5))
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
