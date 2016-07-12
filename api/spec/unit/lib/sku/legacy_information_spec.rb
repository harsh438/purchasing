require './lib/sku/legacy_information.rb'

RSpec.describe LegacyInformation do
  subject(:legacy_info)     { described_class.new(sku) }
  let(:sku)                 { create(:sku) }
  let!(:prod_cat1)          { create(:product_category, pID: sku.product_id, catID: 20) }
  let!(:cat1)               { create(:category, catID: prod_cat1.catID) }
  let!(:prod_cat2)          { create(:product_category, pID: sku.product_id, catID: 50) }
  let!(:cat2)               { create(:category, catID: prod_cat2.catID) }
  let!(:prod_cat3)          { create(:product_category, pID: sku.product_id, catID: 999) }
  let!(:cat3)               { create(:category, catID: prod_cat3.catID, parentID: 50) }
  let!(:video_url)          { create(:product_extend, pID: sku.product_id).embed }
  let!(:first_received)     { create(:pvx_in, pid: sku.product_id).logged }
  let!(:reporting_category) { create(:reporting_category, catid: sku.ordered_catid, pid: sku.product_id) }

  describe "#as_json" do
    it "Includes a legacy_lead_gender" do
      expect(legacy_info.as_json).to include legacy_lead_gender: sku.gender
    end

    it "Includes a legacy_reporting_category" do
      expect(legacy_info.as_json).to include legacy_reporting_category: reporting_category.catid
    end

    context "When there are multiple categories.." do
      it "Includes the correct legacy_breadcrumb_category" do
        expect(legacy_info.as_json).to include legacy_breadcrumb_category: prod_cat1.catID
      end
    end

    it "Includes a legacy_season" do
      expect(legacy_info.as_json).to include legacy_season: sku.season
    end

    it "Includes a legacy_supplier_sku" do
      expect(legacy_info.as_json).to include legacy_supplier_sku: sku.manufacturer_sku
    end

    it "Includes a legacy_video_url" do
      expect(legacy_info.as_json).to include legacy_video_url: video_url
    end

    it "Includes a legacy_reporting_category_name" do
      expect(legacy_info.as_json).to include legacy_reporting_category_name: sku.language_category.catName
    end

    it "Includes a legacy_first_received_at" do
      expect(legacy_info.as_json).to include legacy_first_received_at: first_received
    end

    it "Includes a legacy_more_from_category" do
      expect(legacy_info.as_json).to include legacy_more_from_category: sku.ordered_catid
    end
  end
end
