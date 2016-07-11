require './lib/sku/legacy_information.rb'

RSpec.describe LegacyInformation do
  subject(:legacy_info) { described_class.new(sku) }
  let(:sku)             { create(:sku, :with_multiple_categories) }

  describe "#as_json" do
    it "Includes a legacy_lead_gender" do
      expect(legacy_info.as_json).to include legacy_lead_gender: sku.gender
    end

    it "Includes a legacy_reporting_category" do
      expect(legacy_info.as_json).to include legacy_reporting_category: sku.category_name
    end

    context "When there are multiple categories.." do


      it "Includes the correct legacy_breadcrumb_category" do
        expect(legacy_info.as_json).to include legacy_breadcrumb_category: 20
      end
    end

    it "Includes a legacy_season" do
      expect(legacy_info.as_json).to include legacy_season: sku.season
    end

    it "Includes a legacy_supplier_sku" do
      expect(legacy_info.as_json).to include legacy_supplier_sku: sku.manufacturer_sku
    end
  end
end
