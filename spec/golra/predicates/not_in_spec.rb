# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::NotIn) do
  describe ".apply" do
    it "applies NOT IN condition" do
      scope = double("scope")
      where_chain = double("where_chain")

      expect(scope).to(receive(:where).and_return(where_chain))
      expect(where_chain).to(receive(:not).with(id: [1, 2, 3]).and_return(scope))

      described_class.apply(scope, :id, [1, 2, 3])
    end
  end
end
