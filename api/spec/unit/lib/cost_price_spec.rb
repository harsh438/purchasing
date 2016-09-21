RSpec.describe CostPrice do
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
        a_hash_including(:discount => "5.00%"),
        a_hash_including(:discount => "6.00%")
      ]
    end

    it '#calculate_cost_price' do
      expect(subject.send(:calculate_cost_price, 100, '10.0%')).to eq 90
    end

    it '#purchase_order_details' do
      purchase_orders_lines = subject.send(:purchase_order_details, 123)
      expect(purchase_orders_lines.count).to eq 3
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

    it '#update_cost_prices' do
      po_lines = PurchaseOrderLineItem.where(po_number: 123)
      expect(po_lines.pluck(:cost)).to match [15.0, 15.0, 15.0]
      expect(po_lines.pluck(:supplier_list_price)).to match [15.0, 15.0, 15.0]
      skus = Sku.where(id: po_lines.pluck(:sku_id))
      expect(skus.pluck(:cost_price)).to match [19.99, 19.99, 19.99]
      product = Product.where(id: po_lines.pluck(:product_id))
      expect(subject.send(:update_cost_prices, po_lines, discount)).to be true
      po_lines.reload
      sku.reload
      product.reload
      expect(po_lines.pluck(:cost)).to match [14.25, 14.25, 14.25]
      expect(po_lines.pluck(:supplier_list_price)).to match [15.0, 15.0, 15.0]
      expect(skus.pluck(:cost_price)).to match [14.25, 14.25, 14.25]
      expect(product.pluck(:cost)).to match [14.25, 14.25, 14.25]
    end

    it '#process_csv' do
      csv_data = subject.csv_data
      result = subject.process_csv(csv_data)
      expect(result).to eq "Updated Purchase Orders 123,234"
    end

    it '#process!' do
      result = subject.process!
      expect(result).to eq "Updated Purchase Orders 123,234"
    end
  end
end
