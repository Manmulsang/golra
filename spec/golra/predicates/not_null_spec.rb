# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::NotNull) do
  describe ".apply" do
    it "applies IS NOT NULL when value is true" do
      scope = double("scope")
      where_chain = double("where_chain")

      expect(scope).to(receive(:where).and_return(where_chain))
      expect(where_chain).to(receive(:not).with(name: nil).and_return(scope))

      described_class.apply(scope, :name, true)
    end

    it "applies IS NULL when value is false" do
      scope = double("scope")
      expect(scope).to(receive(:where).with(name: nil).and_return(scope))

      described_class.apply(scope, :name, false)
    end
  end
end
