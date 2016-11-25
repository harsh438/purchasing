RSpec.describe Sku::Generator do
  before { create(:base_sku, :with_product, :with_barcode, :sized, season: Season.first) }

  let(:lang_category) { create(:language_category) }

  let(:new_sku_attrs) { { manufacturer_sku: 'SV507-A59',
                          product_name: 'The big name',
                          lead_gender: 'M',
                          vendor_id: create(:vendor).id,
                          manufacturer_color: 'blueish',
                          manufacturer_size: '14',
                          season: Season.first.nickname,
                          color: 'blue',
                          size: 'small',
                          color_family: 'blues',
                          size_scale: 'thumb',
                          inv_track: 'O',
                          cost_price: 10.00,
                          list_price: 15.00,
                          price: 5.00,
                          barcode: '5052094029950',
                          listing_genders: 'M',
                          category_id: lang_category.category.id,
                          category_name: lang_category.name } }

  context 'find a sku based on a previously existing sku' do
    it 'should retrieve the existing sku' do
      sku = subject.generate({ manufacturer_sku: 'mansku-dooby-doo',
                               barcode: Barcode.first.barcode,
                               season: Season.first.nickname,
                               inv_track: 'O' })

      %i(sku size color product option language_product_option language_category element).each do |attribute|
        expect(sku.send(attribute)).to be_present
      end
    end
  end

  context 'generate a sku based on the information passed in the attributes' do
    subject do
      described_class.new.generate(new_sku_attrs)
    end

    it { is_expected.to_not be_nil }

    it 'should have the correct gender' do
      expect(subject.gender).to eq('M')
    end

    it 'should have a vendor' do
      expect(subject.vendor).to be_a(Vendor)
    end

    it 'should create a product' do
      expect(subject.product).to be_a(Product)
      expect(subject.product.price).to eq(new_sku_attrs[:price])
    end

    it 'should create a language product option' do
      expect(subject.language_product_option).to be_a(LanguageProductOption)
      expect(subject.language_product_option.name).to eq(new_sku_attrs[:size])
    end

    it 'should set the season correctly' do
      expect(subject.season).to eq(Season.first)
    end

    it 'should create an option' do
      expect(subject.option).to be_a(Option)
      expect(subject.option.size).to eq(new_sku_attrs[:manufacturer_size])
    end

    it 'should create an element' do
      expect(subject.element).to be_a(Element)
    end

    it 'should create the relationships between the product and its option and element' do
      expect(subject.language_product_option.element).to be_a(Element)
      expect(subject.element.id).to eq(subject.language_product_option.element.id)
    end

    it 'should create a language category' do
      expect(subject.language_category).to be_a(LanguageCategory)
    end

    it 'should have a barcode' do
      expect(subject.barcodes.first.barcode).to eq('5052094029950')
    end

    it 'should create a category' do
      expect(subject.language_category.category).to be_a(Category)
    end

    it 'should create a language product' do
      expect(subject.language_product).to be_a(LanguageProduct)
      expect(subject.language_product.name).to eq('The big name')
    end
  end
  context "size validation" do
    subject(:generator) { described_class.new }

    context "same sku, new season, new size" do
      before do
        generator.generate(new_sku_attrs)
        new_sku_attrs[:size] = 'medium'
        new_sku_attrs[:season] = 'SS17'
      end

      it "raises error" do
        expect { generator.generate(new_sku_attrs) }.to raise_error ActiveRecord::RecordInvalid
      end
    end
    context "same sku, new season, same size" do
      before do
        generator.generate(new_sku_attrs)
        new_sku_attrs[:season] = 'SS17'
      end
      it "generates sku" do
        expect { generator.generate(new_sku_attrs) }.to change(Sku, :count).by(1)
      end
    end
  end
end
