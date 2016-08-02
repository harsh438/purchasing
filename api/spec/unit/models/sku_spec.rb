RSpec.describe Sku do
  describe '.with_barcode' do
    let(:product) { create(:product) }

    before do
      create(:sku_without_barcode, sku: 'ABC123', product: product)
      create(:sku, sku: 'DEF123', product: product)
      # a sku with 2 of the same barcodes
      create(:sku, sku: 'GHI123', product: product).tap do |sku|
        sku.barcodes.create!(barcode: sku.barcodes.first.barcode)
      end
    end

    it 'returns only skus with that have barcodes' do
      expect(product.skus.with_barcode.pluck(:sku)).to eq %w(DEF123 GHI123)
    end
  end
end
