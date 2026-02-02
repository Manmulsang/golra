# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Predicates::StartWith) do
  describe ".apply" do
    it "applies LIKE prefix condition" do
      scope = double("scope")
      arel_table = double("arel_table")
      arel_attribute = double("arel_attribute")
      klass = double("klass", arel_table: arel_table)

      allow(scope).to(receive(:klass).and_return(klass))
      allow(arel_table).to(receive(:[]).with(:name).and_return(arel_attribute))
      allow(arel_attribute).to(receive(:matches).with("kim%").and_return("name LIKE 'kim%'"))
      expect(scope).to(receive(:where).with("name LIKE 'kim%'").and_return(scope))

      described_class.apply(scope, :name, "kim")
    end
  end
end
