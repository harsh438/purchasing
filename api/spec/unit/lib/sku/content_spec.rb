require './lib/sku/content.rb'

RSpec.describe Content do
  subject(:content)      { described_class.new(language_product) }
	let(:language_product) { create(:language_product) }

	describe "#as_json" do
		it "Includes a lang attribute" do
			expect(content.as_json).to include lang: language_product.langID
    end

    it "Includes a content key" do
      expect(content.as_json).to include :content
    end

    context "content key's value contains.... " do
      it "a name" do
        expect(content.as_json[:content]).to include name: language_product.pName
      end

      it "a teaser" do
        expect(content.as_json[:content]).to include teaser: language_product.pTeaser
      end

      context "a legacy_slug which..." do
        let(:language_product_set_name) { create(:language_product, name: "MarIah's DeNesik'") }
        let(:content_new)               { described_class.new(language_product_set_name) }

        it "downcases a name" do
          expect(language_product_set_name.pName).to receive(:downcase).and_call_original
          content_new.as_json
        end

        it "replaces spaces with -" do

          legacy_slug = content_new.as_json[:content][:legacy_slug]
          expect(legacy_slug.match(/\s/)).to be nil
        end

        it "replaces ' with nothing" do
          legacy_slug = content_new.as_json[:content][:legacy_slug]
          expect(legacy_slug.match(/'/)).to be nil
        end

        it "adds a pid to the end" do
          legacy_slug = content_new.as_json[:content][:legacy_slug]
          expect(legacy_slug).to include "#{language_product_set_name.pID}"
        end
      end
    end
  end
end
