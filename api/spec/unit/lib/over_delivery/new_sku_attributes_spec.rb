require 'spec_helper'

describe OverDelivery::NewSkuAttributes do

  let(:sku_1) { create(:base_sku, :with_product, :with_barcode) }
  let(:language_category) { LanguageCategory.find_by!(id: new_attributes.sku_attrs['category_id']) }
  let(:season) { 'test_season' }

  subject(:new_attributes) { described_class.new(sku_1, season) }

  context "building new sku attributes" do
    it "returns correct attributes" do
      expect { new_attributes.build }.to change {
        [
          new_attributes.sku_attrs['season'],
          new_attributes.sku_attrs['barcode'],
          new_attributes.sku_attrs['category_id'],
          new_attributes.sku_attrs['category_name'],
          new_attributes.sku_attrs['internal_sku'],
          new_attributes.sku_attrs['lead_gender'],
        ]
      }.from([
        sku_1.season.nickname,
        nil,
        sku_1.category_id,
        nil,
        nil,
        nil,
      ]).to([
        season,
        sku_1.barcodes.first.barcode,
        language_category.category_id,
        language_category.name,
        sku_1.sku,
        sku_1.gender,
      ])
    end
  end
end
