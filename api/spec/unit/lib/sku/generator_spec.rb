describe Sku::Generator do
  context 'find a sku based on a previously existing sku' do
    before { create(:sku) }

    it 'should retrieve the exitsing sku' do
      sku = subject.sku_from!({ manufacturer_sku: 'MANU-FACTURER-SKU-11' })

      expect(sku.sku.present?).to eq(true)
      expect(sku.size.present?).to eq(true)
      expect(sku.color.present?).to eq(true)
      expect(sku.product.present?).to eq(true)
      expect(sku.product_option.present?).to eq(true)
      expect(sku.element.present?).to eq(true)
    end
  end

  context 'generate a sku based on the information passed in the attributes' do
    it 'should create a product and an option' do
      sku = subject.sku_from!({ manufacturer_sku: 'MANU-FACTURER-SKU-12',
                                manufacturer_color: 'blueish',
                                manufacturer_size: 'smallish',
                                season: 'witch',
                                color: 'blue',
                                size: 'small',
                                color_family: 'blues',
                                size_scale: 'thumb',
                                cost_price: 10.00,
                                list_price: 15.00,
                                price: 5.00 })

      expect(sku).to_not be_nil
      expect(sku.product).to be_a(Product)
      expect(sku.option).to be_a(Option)
    end
  end
end
