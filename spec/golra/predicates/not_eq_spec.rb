# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::NotEq) do
  describe ".apply" do
    it "applies where.not condition" do
      scope = double("scope")
      where_chain = double("where_chain")

      expect(scope).to(receive(:where).and_return(where_chain))
      expect(where_chain).to(receive(:not).with(name: "kim").and_return(scope))

      described_class.apply(scope, :name, "kim")
    end
  end
end
