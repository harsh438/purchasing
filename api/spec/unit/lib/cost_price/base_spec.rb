RSpec.describe CostPrice::Base do
  let(:file) { StringIO.new }
  let(:logger) { Logger.new(file) }

  let(:subject) do
    described_class.new(logger, 'spec/fixtures/files/sample_po_cost_price.csv')
  end

  let(:discount) { '5.00%' }

  let(:sku) { create(:sku, cost_price: 10) }

  before(:each) do
    create_purchase_orders
  end

  def create_purchase_orders
    create_list(:purchase_order_line_item,
                3,
                :with_product,
                status: 4,
                season: 'AW15',
                po_number: 123,
                cost: 15,
                supplier_list_price: 15,
                delivery_date: Time.new(2015, 9, 1))

    create_list(:purchase_order_line_item,
                2,
                :with_product,
                :arrived,
                status: 2,
                season: 'AW16',
                po_number: 234,
                cost: 15,
                supplier_list_price: 20,
                delivery_date: Time.new(2016, 9, 1))
  end

  describe 'update cost prices' do
    it '#csv_data' do
      csv_data = subject.csv_data
      expect(csv_data).to match [
        a_hash_including(:discount => '5.00%'),
        a_hash_including(:discount => '6.00%')
      ]
    end

    it '#update_sku_cost_price' do
      expect(sku.cost_price).to eq 10
      subject.send(:update_sku_cost_price, sku.id, 8)
      sku.reload
      expect(sku.cost_price).to eq 8
    end

    it '#update_purchase_order_cost' do
      purchase_order_line = PurchaseOrderLineItem.where(po_number: 123).first
      expect(purchase_order_line.cost).to eq 15.0
      subject.send(:update_purchase_order_cost, purchase_order_line, 100.00)
      purchase_order_line.reload
      expect(purchase_order_line.cost).to eq 100.0
    end

    it '#process_csv' do
      csv_data = subject.csv_data
      expect { subject.process_csv(csv_data) }
        .to raise_error NotImplementedError
    end
  end
end
