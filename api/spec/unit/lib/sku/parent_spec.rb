require './lib/sku/parent.rb'

RSpec.describe Parent do
  describe "#as_json" do
    subject(:parent) { described_class.new(sku) }
    let(:sku)        { create(:sku, on_sale: true) }

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
      expect(parent.as_json).to include sale_price: sku.product.pSalesPrice
    end

    it "Includes an active key with a value" do
      expect(parent.as_json).to include active: sku.product.pAvail
    end

    it "Includes use_legacy_slug" do
      expect(parent.as_json).to include use_legacy_slug: true
    end

    it "Includes a barcode" do
      expect(parent.as_json).to include barcode: sku.product.pUDFValue1
    end

    it "Includes a cost_price" do
      expect(parent.as_json).to include cost_price: sku.cost_price
    end

    it "Includes a brand" do
      expect(parent.as_json).to include brand: sku.vendor.name
    end
  end
end


#     # "legacy_supplier_sku": ds_products.pNum,
#       # "price": ds_products.price - [pPrice.to_f, 0].max
#         # "sale_price": checks ds_options.psale for Y ? nil or ds_products.pSalePrice.to_f (!?!) why do we set sale here?
#           # "active": ds_products.pAvail
#             # "shipping_category": ds_product_categories. get taxons mess!! what is a shipping category?
#                   # "dropshipment": ds_products.pUDFValue5 == 'D-R-P' -> do we sell or will someone else fulfil
