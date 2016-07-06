require './lib/sku/child.rb'

RSpec.describe Child do
	let(:sku)   { create(:sku) }
	subject(:child) { described_class.new(sku) }

	describe "#as_json" do
		it "Includes a sku number" do
			expect(child.as_json).to include sku: sku.sku
		end

		it "Includes a barcode" do
			expect(child.as_json).to include barcode: sku.barcodes.map(&:barcode)
		end

		it "Includes a price" do
			expect(child.as_json).to include price: sku.price
		end

		it "Includes a cost_price" do
			expect(child.as_json).to include cost_price: sku.cost_price
		end

		it "Includes a legacy_brand_size" do
			expect(child.as_json).to include legacy_brand_size: sku.manufacturer_size
		end

		it "Includes an options hash, which includes a size" do
			expect(child.as_json).to include options: { size: sku.size }
		end
	end
end
