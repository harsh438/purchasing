RSpec.describe Sku do
  describe "shoulda", type: :shoulda do
    it { should belong_to(:product).touch(true) }
    it { should belong_to(:vendor) }
    it { should belong_to(:element) }
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
end
