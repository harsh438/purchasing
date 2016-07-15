require './lib/sku/children.rb'

RSpec.describe Children do
	subject(:children) { described_class.new(sku) }
	let(:sku)          { create(:sku) }

	describe "#as_json" do
		it "Includes a sku number" do
			expect(children.as_json.first).to include sku: sku.sku
		end

		it "Includes a barcode" do
			expect(children.as_json.first).to include barcode: sku.barcodes.map(&:barcode)
		end

		it "Includes a price" do
			expect(children.as_json.first).to include price: sku.price
		end

		it "Includes a cost_price" do
			expect(children.as_json.first).to include cost_price: sku.cost_price
		end

		it "Includes a legacy_brand_size" do
			expect(children.as_json.first).to include legacy_brand_size: sku.manufacturer_size
		end

		it "Includes an options hash, which includes a size" do
			expect(children.as_json.first).to include options: { size: sku.size }
		end
	end
end
