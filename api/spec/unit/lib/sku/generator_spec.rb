describe Sku::Generator do
  subject { Sku::Generator }
  context 'generate a sku based on a previously existing sku' do
    before { create(:sku) }

    it 'should generate a new sku' do
      sku = subject.sku_from!({ manufacturer_sku: 'MANU-FACTURER-SKU-11' })

      expect(sku.sku.present?).to eq(true)
      expect(sku.size.present?).to eq(true)
      expect(sku.color.present?).to eq(true)
      expect(sku.product.present?).to eq(true)
      expect(sku.product_option.present?).to eq(true)
      expect(sku.element.present?).to eq(true)
    end
  end
end
