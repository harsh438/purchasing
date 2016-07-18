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
                               :with_skus,
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
    it "Includes all the correct parent information" do
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
        brand: vendor.name
      )
      expect(prod.as_json[:properties]).to include gender: gender
      expect(prod.as_json[:properties]).to include colour: colour
    end

    it "Includes product_image information" do
      allow_any_instance_of(ProductImageSerializer)
        .to receive(:as_json)
          .and_return("IMAGES!")
      expect(prod.as_json).to include images: [ "IMAGES!", "IMAGES!" ]
    end

    it "Includes all the correct legacy information" do
      expect(prod.as_json).to include(
        legacy_lead_gender: prod.master_sku.gender,
        legacy_season: prod.master_sku.season,
        legacy_reporting_category: reporting_category.catid,
        legacy_supplier_sku: prod.manufacturer_sku,
        legacy_reporting_category_name: prod.master_sku.language_category.catName,
        legacy_more_from_category: prod.master_sku.ordered_catid,
        legacy_first_received_at: first_received
        )
    end

    it "Includes all the correct Part information" do
      expect(prod.as_json).to include( parts: item_codes )
    end
  end
end
