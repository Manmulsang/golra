# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::In) do
  describe ".apply" do
    it "applies IN condition" do
      scope = double("scope")
      expect(scope).to(receive(:where).with(id: [1, 2, 3]).and_return(scope))

      described_class.apply(scope, :id, [1, 2, 3])
    end

    it "handles empty array" do
      scope = double("scope")
      expect(scope).to(receive(:where).with(id: []).and_return(scope))

      described_class.apply(scope, :id, [])
    end
  end
end
