RSpec.describe Product do
  let(:vendor)             { build(:vendor) }
  let(:gender)             { prod.listing_genders }
  let(:colour)             { prod.color }
  let(:dropship)           { prod.dropshipment }
  let(:price)              { prod.price }
  let(:active)             { prod.active }
  let(:sales_price)        { prod.sale_price }
  let(:barcode)            { prod.master_sku.barcodes.latest }
  let(:first_received)     { prod.pvx_ins.first.logged }
  let(:item_codes)         { prod.kit_managers.map(&:item_code) }
  let(:reporting_category) { prod.reporting_category }
  subject(:prod)           { create(
                               :product,
                               :with_master_sku,
                               :with_reporting_category,
                               :with_pvx_in,
                               :with_kit_managers,
                               listing_genders: "M",
                               color: "blue",
                               dropshipment: "D-R-P",
                               sale_price: 2.99,
                               active: "Y",
                               cost: 2.99,
                               vendor: vendor,
                               product_images: build_list(:product_image, 2)
                             )
  }

  describe "#as_json" do
    context "When the product is sized" do
      before do
        prod.skus += build_list(:sku, 2, vendor: prod.vendor)
      end

      it "Includes all the correct information" do
        allow_any_instance_of(ProductImageSerializer).to receive(:as_json)
          .and_return("IMAGES!")
        expect(prod.as_json).to include(
          id: prod.id,
          sku: prod.id,
          price: price,
          sale_price: sales_price,
          active: active,
          use_legacy_slug: true,
          barcode: barcode.barcode,
          cost_price: prod.cost,
          dropshipment: dropship,
          brand: vendor.name,
          parts: item_codes,
          legacy_lead_gender: prod.master_sku.gender,
          legacy_season: prod.master_sku.season,
          legacy_reporting_category: reporting_category.catid,
          legacy_supplier_sku: prod.manufacturer_sku,
          legacy_reporting_category_name: prod.master_sku.language_category.catName,
          legacy_more_from_category: prod.master_sku.ordered_catid,
          legacy_first_received_at: first_received
        )
        expect(prod.as_json[:properties]).to include gender: gender
        expect(prod.as_json[:properties]).to include colour: colour
        expect(prod.as_json[:images]).to eq [ "IMAGES!", "IMAGES!" ]
        expect(prod.as_json[:children]).to include(
          sku: prod.skus.first.sku,
          barcode: prod.skus.first.barcodes.first.barcode,
          price: prod.skus.first.price,
          cost_price: prod.skus.first.cost_price,
          legacy_brand_size: prod.skus.first.manufacturer_size,
          options: { size: prod.skus.first.size }
        )
      end
    end

    context "Product is not sized; No children" do
      it "the children key is an empty array" do
        expect(prod.as_json[:children]).to eq []
      end
    end
  end
end
