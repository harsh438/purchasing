require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  let(:processor) do
    create(:batch_file_processor,
           processor_type: 'BatchFiles::Processors::UpdatePurchaseOrderCostPriceByPid',
           csv_header_row: 'po,product,cost_price')
  end

  let(:product_1) { create(:product, id: 555) }
  let(:product_2) { create(:product, id: 222) }
  let(:sku) do
    create(:base_sku,
           :with_barcode,
           :with_product,
           season: Season.all[5])
  end

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

    create(:purchase_order, po_num: 123)
  end

  let(:headers) { %w(po product_id cost_price) }
  let(:contents) { [headers] }

  it_behaves_like "a batchfile" do
    let(:batchfile) { processor }
  end

  it 'validates existence of purchase order' do
    contents << [100_000_000_0, product_1.id, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    errors = batch_file.batch_file_lines.last.processor_errors
    expect(errors).to include(:purchase_order)
  end

  it 'validates existence of purchase order and product' do
    purchase_order_line_item = PurchaseOrderLineItem.first
    contents << [123, product_2.id, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    errors = batch_file.batch_file_lines.last.processor_errors
    expect(errors).to include(:purchase_order_product)
  end

  it 'validates cost price is a number ' do
    contents << [123, product_1.id, 'notanumber']
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    errors = batch_file.batch_file_lines.last.processor_errors
    expect(errors).to include(:cost_price)
  end

  it 'updates cost_price' do
    purchase_order_line_item = PurchaseOrderLineItem.first
    expect(purchase_order_line_item.cost).to eq(15)
    contents << [123, product_1.id, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    expect { validate_and_process(batch_file) }.to change {
      purchase_order_line_item.reload.cost
    }.to(20)
  end
end
