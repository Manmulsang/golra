# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::Eq) do
  describe ".apply" do
    it "applies where condition" do
      scope = double("scope")
      expect(scope).to(receive(:where).with(name: "kim").and_return(scope))

      described_class.apply(scope, :name, "kim")
    end

    it "handles nil value" do
      scope = double("scope")
      expect(scope).to(receive(:where).with(name: nil).and_return(scope))

      described_class.apply(scope, :name, nil)
    end
  end
end
