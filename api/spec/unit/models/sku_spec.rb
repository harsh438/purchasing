RSpec.describe Sku do
  describe "shoulda", type: :shoulda do
    it { should belong_to(:product).touch(true) }
    it { should belong_to(:vendor) }
    it { should belong_to(:element).with_foreign_key(:element_id) }
    it { should belong_to(:language_product).with_foreign_key(:language_product_id) }
    it { should belong_to(:language_category).with_foreign_key(:category_id) }
    it { should belong_to(:option).with_foreign_key(:option_id) }
    it { should belong_to(:language_product_option).with_foreign_key(:language_product_option_id) }
    it { should belong_to(:season).with_foreign_key(:season) }

    it { should have_many(:barcodes) }
    it { should have_many(:pvx_ins).through(:product) }
    it { should have_many(:product_images).through(:product) }
    it { should have_many(:product_categories).with_foreign_key(:pID) }
    it { should have_many(:categories).through(:product_categories) }
    it { should have_many(:purchase_order_line_items) }

    it { should have_one(:reporting_category).through(:product) }

    it { should accept_nested_attributes_for(:barcodes) }

    it { should validate_presence_of(:manufacturer_sku) }
  end

  describe '.with_barcode' do
    let(:product) { create(:product) }

    before do
      create(:base_sku, :sized, sku: 'ABC123', product: product)
      create(:base_sku, :with_product, :sized, :with_barcode, sku: 'DEF123', product: product)
      # a sku with 2 of the same barcodes
      create(:base_sku, :with_product, :sized, :with_barcode, sku: 'GHI123', product: product)
        .tap do |sku|
          sku.barcodes.create!(barcode: sku.barcodes.first.barcode)
        end
    end

    it 'returns only skus that have barcodes' do
      expect(product.skus.with_barcode.pluck(:sku)).to eq %w(DEF123 GHI123)
    end
  end

  describe '#should_be_sized?' do
    let(:sku) { create(:base_sku, :sized) }

    it 'returns true when inv_track is O' do
      expect(sku.should_be_sized?).to be true
    end

    it 'returns false when inv_track is P' do
      sku.update!(inv_track: 'P')
      expect(sku.should_be_sized?).to be false
    end
  end

  describe '#sized?' do
    let(:sku) { create(:base_sku, :sized, :with_barcode, :with_product) }

    it 'returns false if no option' do
      sku.option.delete
      expect(sku.reload.sized?).to be false
    end

    it 'returns false if no element' do
      sku.element.delete
      expect(sku.reload.sized?).to be false
    end

    it 'returns false if no language_product_option' do
      sku.language_product_option.delete
      expect(sku.reload.sized?).to be false
    end

    it "returns false if inv_track == 'P'" do
      sku.update(inv_track: 'P')
      expect(sku.reload.sized?).to be false
    end

    it "returns true if inv_track == 'O', sku has element, option and language_product_option" do
      expect(sku.sized?).to be true
    end
  end
end
