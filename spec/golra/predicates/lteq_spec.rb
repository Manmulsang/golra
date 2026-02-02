# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::Lteq) do
  describe ".apply" do
    it "applies less than or equal condition" do
      scope = double("scope")
      arel_table = double("arel_table")
      arel_attribute = double("arel_attribute")
      klass = double("klass", arel_table: arel_table)

      allow(scope).to(receive(:klass).and_return(klass))
      allow(arel_table).to(receive(:[]).with(:age).and_return(arel_attribute))
      allow(arel_attribute).to(receive(:lteq).with(20).and_return("age <= 20"))
      expect(scope).to(receive(:where).with("age <= 20").and_return(scope))

      described_class.apply(scope, :age, 20)
    end
  end
end
