require './lib/sku/children.rb'

RSpec.describe Children do
	subject(:children) { described_class.new(sku) }
	let(:sku)          { create(:sku) }

	describe "#as_json" do
		it "Includes a sku number" do
			expect(children.as_json.first).to include(
				sku: sku.sku,
				barcode: sku.barcodes.map(&:barcode),
				price: sku.price,
				cost_price: sku.cost_price,
				legacy_brand_size: sku.manufacturer_size,
				options: { size: sku.size }
			)
		end
	end
end
