require './lib/sku/parent.rb'

RSpec.describe Parent do
  describe "#as_json" do
    subject(:parent) { described_class.new(sku) }
    let(:sku)        { create(:sku_without_product, on_sale: true) }
    let(:gender)     { prod.pUDFValue3 }
    let(:colour)     { prod.pUDFValue2 }
    let(:dropship)   { prod.pUDFValue5 }
    let!(:prod)      { create(:product, id: sku.product_id,
                              pUDFValue3: "M",
                              pUDFValue2: "blue",
                              pUDFValue5: "D-R-P",
                              pSalesPrice: 2.99,
                              pUDFValue1: 4.99,
                              pAvail: "Y")
    }

    it "Includes a product id" do
      expect(parent.as_json).to include id: sku.product_id
    end

    it "Includes a sku" do
      expect(parent.as_json).to include sku: sku.product_id
    end

    it "Includes a price" do
      expect(parent.as_json).to include price: sku.price
    end

    it "Includes a sale_price" do
      expect(parent.as_json).to include sale_price: prod.pSalesPrice
    end

    it "Includes an active key with a value" do
      expect(parent.as_json).to include active: prod.pAvail
    end

    it "Includes use_legacy_slug" do
      expect(parent.as_json).to include use_legacy_slug: true
    end

    it "Includes a barcode" do
      expect(parent.as_json).to include barcode: prod.pUDFValue1
    end

    it "Includes a cost_price" do
      expect(parent.as_json).to include cost_price: sku.cost_price
    end

    it "Includes a brand" do
      expect(parent.as_json).to include brand: sku.vendor.name
    end

    context "Includes properties which has ..." do
      it "A gender" do
        expect(parent.as_json[:properties]).to include gender: gender
      end

      it "A colour" do
        expect(parent.as_json[:properties]).to include colour: colour
      end
    end

    it "Includes a dropshipment" do
      expect(parent.as_json).to include dropshipment: dropship
    end
  end
end

