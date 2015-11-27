describe Sku::Generator do
  before { create(:sku) }

  let(:new_sku_attrs) { { manufacturer_sku: 'MANU-FACTURER-SKU-12',
                          manufacturer_color: 'blueish',
                          manufacturer_size: 'smallish',
                          season: 'witch',
                          color: 'blue',
                          size: 'small',
                          color_family: 'blues',
                          size_scale: 'thumb',
                          cost_price: 10.00,
                          list_price: 15.00,
                          price: 5.00 } }

  context 'find a sku based on a previously existing sku' do
    it 'should retrieve the exitsing sku' do
      sku = subject.sku_from!({ manufacturer_sku: 'MANU-FACTURER-SKU-11' })

      expect(sku.sku.present?).to eq(true)
      expect(sku.size.present?).to eq(true)
      expect(sku.color.present?).to eq(true)
      expect(sku.product.present?).to eq(true)
      expect(sku.language_product_option.present?).to eq(true)
      expect(sku.language_category.present?).to eq(true)
      expect(sku.element.present?).to eq(true)
    end
  end

  context 'generate a sku based on the information passed in the attributes' do
    subject { described_class.new.sku_from!(new_sku_attrs) }

    it { is_expected.to_not be_nil }

    it 'should create a product' do
      expect(subject.product).to be_a(Product)
      expect(subject.product.price).to eq(new_sku_attrs[:price])
    end

    it 'should create an option' do
      expect(subject.language_product_option).to be_a(LanguageProductOption)
    end

    it 'should create an element' do
      expect(subject.element).to be_a(Element)
    end

    it 'should create the relationships between the product and its option and element' do
      expect(subject.language_product_option.element).to be_a(Element)
      expect(subject.language_product_option.option).to be_a(Option)
      expect(subject.element.id).to eq(subject.language_product_option.element.id)
    end

    it 'should create a language category' do
      expect(subject.language_category).to be_a(LanguageCategory)
    end

    it 'should create a category' do
      expect(subject.language_category.category).to be_a(Category)
    end

    it 'should create a language product' do
      expect(subject.language_product).to be_a(LanguageProduct)
    end
  end
end
