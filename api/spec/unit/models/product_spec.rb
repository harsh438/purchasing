RSpec.describe Product do
  let(:vendor)      { build(:vendor) }
  let(:gender)      { prod.listing_genders }
  let(:colour)      { prod.color }
  let(:dropship)    { prod.dropshipment }
  let(:price)       { prod.price }
  let(:active)      { prod.active }
  let(:sales_price) { prod.sale_price }
  let(:barcode)     { prod.master_sku.barcodes.latest }
  subject(:prod)    { create(:product, :with_skus,
                            listing_genders: "M",
                            color: "blue",
                            dropshipment: "D-R-P",
                            sale_price: 2.99,
                            active: "Y",
                            cost: 2.99,
                            vendor: vendor,
                            )
  }

  describe "#as_json" do
    it "Includes all the correct information" do
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
  end
end
