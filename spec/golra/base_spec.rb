# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Golra::Base) do
  let(:string_column) { double("column", type: :string) }
  let(:integer_column) { double("column", type: :integer) }
  let(:user_columns_hash) { { "name" => string_column, "age" => integer_column } }
  let(:user_model) { double("User", name: "User", columns_hash: user_columns_hash) }

  before do
    stub_const("User", user_model)
    stub_const("UserGolra", Class.new(described_class) do
      permit :name, :age
    end)
  end

  describe ".model_class" do
    it "infers model from class name" do
      expect(UserGolra.model_class).to(eq(User))
    end
  end

  describe ".parse_key" do
    it "parses key with __" do
      attribute, predicate = UserGolra.send(:parse_key, "name__eq")
      expect(attribute).to(eq(:name))
      expect(predicate).to(eq(:eq))
    end

    it "returns nil for invalid key" do
      attribute, predicate = UserGolra.send(:parse_key, "invalid")
      expect(attribute).to(be_nil)
      expect(predicate).to(be_nil)
    end
  end

  describe ".apply" do
    it "applies filters to scope" do
      scope = double("scope")
      expect(scope).to(receive(:where).with(name: "kim").and_return(scope))

      UserGolra.apply(scope, { name__eq: "kim" })
    end

    it "casts value before applying" do
      scope = double("scope")
      arel_table = double("arel_table")
      arel_attribute = double("arel_attribute")
      klass = double("klass", arel_table: arel_table)

      allow(scope).to(receive(:klass).and_return(klass))
      allow(arel_table).to(receive(:[]).with(:age).and_return(arel_attribute))
      allow(arel_attribute).to(receive(:gt).with(20).and_return("age > 20"))
      expect(scope).to(receive(:where).with("age > 20").and_return(scope))

      UserGolra.apply(scope, { age__gt: "20" })
    end

    it "raises error for unsupported predicate for type" do
      scope = double("scope")

      expect do
        UserGolra.apply(scope, { age__cont: "20" })
      end.to(raise_error(Golra::UnsupportedPredicateError))
    end

    context "with custom filter method" do
      before do
        stub_const("CustomGolra", Class.new(described_class) do
          permit :age

          class << self
            def age__between(scope, value)
              scope.where(age: value[0]..value[1])
            end

            def model_class
              User
            end
          end
        end)
      end

      it "calls custom method" do
        scope = double("scope")
        expect(scope).to(receive(:where).with(age: 20..30).and_return(scope))

        CustomGolra.apply(scope, { age__between: [20, 30] })
      end
    end

    context "with association" do
      let(:post_columns_hash) { { "title" => string_column } }
      let(:post_model) { double("Post", name: "Post", columns_hash: post_columns_hash, table_name: "posts") }

      before do
        stub_const("Post", post_model)
        stub_const("PostGolra", Class.new(described_class) do
          permit :title
        end)
        stub_const("UserWithPostsGolra", Class.new(described_class) do
          permit :name
          association :posts, PostGolra
        end)
      end

      it "applies join filter" do
        scope = double("scope")
        klass = double("klass")
        arel_table = double("arel_table")
        arel_attribute = double("arel_attribute")

        allow(scope).to(receive(:klass).and_return(klass))
        allow(scope).to(receive(:joins_values).and_return([]))
        allow(klass).to(receive(:arel_table).and_return(arel_table))
        allow(arel_table).to(receive(:[]).with("posts.title").and_return(arel_attribute))
        allow(arel_attribute).to(receive(:matches).with("%ruby%").and_return("posts.title LIKE '%ruby%'"))

        expect(scope).to(receive(:joins).with(:posts).and_return(scope))
        expect(scope).to(receive(:where).with("posts.title LIKE '%ruby%'").and_return(scope))

        UserWithPostsGolra.apply(scope, { "posts::title__cont" => "ruby" })
      end

      it "raises error if association not defined" do
        scope = double("scope")

        expect do
          UserGolra.apply(scope, { "posts::title__cont" => "ruby" })
        end.to(raise_error(Golra::AssociationNotFoundError))
      end
    end

    context "with sort" do
      it "applies single sort" do
        scope = double("scope")
        expect(scope).to(receive(:order).with(age: :desc).and_return(scope))

        UserGolra.apply(scope, { sort: "age__desc" })
      end

      it "applies multiple sorts in order" do
        scope = double("scope")
        expect(scope).to(receive(:order).with(age: :desc).ordered.and_return(scope))
        expect(scope).to(receive(:order).with(name: :asc).ordered.and_return(scope))

        UserGolra.apply(scope, { sort: ["age__desc", "name__asc"] })
      end

      it "raises error for invalid direction" do
        scope = double("scope")

        expect do
          UserGolra.apply(scope, { sort: "age__invalid" })
        end.to(raise_error(Golra::InvalidSortError))
      end

      it "raises error for non-permitted attribute" do
        scope = double("scope")

        expect do
          UserGolra.apply(scope, { sort: "password__desc" })
        end.to(raise_error(Golra::UnpermittedAttributeError))
      end
    end
  end
end
