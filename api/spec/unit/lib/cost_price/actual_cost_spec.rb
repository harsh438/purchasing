 RSpec.describe CostPrice::ActualCost do
  let(:file) { StringIO.new }
  let(:logger) { Logger.new(file) }

  let(:subject) do
    described_class.new(logger, 'spec/fixtures/files/sample_actual_cost.csv')
  end

  let(:sku) { create(:sku, cost_price: 10) }

  let(:product_1) { create(:product, id: 555) }
  let(:product_2) { create(:product, id: 222) }


  before(:each) do
    create_purchase_orders
  end

  def create_purchase_orders
    create_list(:purchase_order_line_item,
                3,
                status: 4,
                product_id: product_1.id,
                season: 'AW15',
                po_number: 123,
                cost: 15,
                supplier_list_price: 15,
                delivery_date: Time.new(2015, 9, 1))

    create_list(:purchase_order_line_item,
                2,
                :arrived,
                product_id: product_2.id,
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
        a_hash_including(:actual_cost => 1.99),
        a_hash_including(:actual_cost => 10.79)
      ]
    end

    it '#purchase_order_details' do
      purchase_orders_lines = subject.send(:purchase_order_details, 123, 555)
      expect(purchase_orders_lines.count).to eq 3
    end

    it '#update_cost_prices' do
      lines = PurchaseOrderLineItem.where('po_number = ? and pid = ?', 123, 555)
      expect(lines.pluck(:cost)).to match [15.0, 15.0, 15.0]
      skus = Sku.where(id: lines.pluck(:sku_id))
      expect(skus.pluck(:cost_price)).to match [19.99, 19.99, 19.99]
      product = Product.where(id: lines.pluck(:product_id))
      expect(subject.send(:update_cost_prices, lines, 1.99)).to be true
      lines.reload
      sku.reload
      product.reload
      expect(lines.pluck(:cost)).to match [1.99, 1.99, 1.99]
      expect(skus.pluck(:cost_price)).to match [1.99, 1.99, 1.99]
      expect(product.pluck(:cost)).to match [1.99]
    end
  end
end
