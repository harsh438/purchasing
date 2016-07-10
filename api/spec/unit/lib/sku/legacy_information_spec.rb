require './lib/sku/legacy_information.rb'

RSpec.describe LegacyInformation do
  subject(:legacy_info) { described_class.new(sku) }
  let(:sku)             { create(:sku) }
  let(:category)        { create(:category) }
  let(:category_2)      { create(:category) }
  let(:prod_cat)        { create(:product_category, catID: category.id, pID: sku.product_id) }
  let(:prod_cat_2)      { create(:product_category, catID: category_2.id, pID: sku.product_id) }

  describe "#as_json" do
    it "Includes a legacy_lead_gender" do
      expect(legacy_info.as_json).to include legacy_lead_gender: sku.gender
    end

    it "Includes a legacy_reporting_category" do
      expect(legacy_info.as_json).to include legacy_reporting_category: sku.category_name
    end

    xit "Includes a legacy_breadcrumb_category" do
      expect(legacy_info.as_json).to include legacy_breadcrumb_category: sku.lowest_catid
    end

    it "Includes a legacy_season" do
      expect(legacy_info.as_json).to include legacy_season: sku.season
    end
  end
end
