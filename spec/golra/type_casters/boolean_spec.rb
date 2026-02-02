# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::TypeCasters::Boolean) do
  describe ".cast!" do
    it "returns true for true" do
      expect(described_class.cast!(true)).to(be(true))
    end

    it "returns false for false" do
      expect(described_class.cast!(false)).to(be(false))
    end

    it "converts 'true' string to true" do
      expect(described_class.cast!("true")).to(be(true))
    end

    it "converts 'false' string to false" do
      expect(described_class.cast!("false")).to(be(false))
    end

    it "converts '1' to true" do
      expect(described_class.cast!("1")).to(be(true))
    end

    it "converts '0' to false" do
      expect(described_class.cast!("0")).to(be(false))
    end

    it "converts 1 to true" do
      expect(described_class.cast!(1)).to(be(true))
    end

    it "converts 0 to false" do
      expect(described_class.cast!(0)).to(be(false))
    end

    it "handles nil" do
      expect(described_class.cast!(nil)).to(be_nil)
    end

    it "raises CastError for invalid value" do
      expect { described_class.cast!("maybe") }.to(raise_error(Golra::CastError))
    end
  end
end
