require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  include_context 'batchfile purchase order updates by product'

  let(:headers) { %w(po product_id list_price) }
  let(:contents) { [headers] }
  let(:skus) { Sku.all }

  let(:processor) do
    create(:batch_file_processor,
           processor_type: 'BatchFiles::Processors::UpdatePurchaseOrderListPriceByPid',
           csv_header_row: headers)
  end

  it_behaves_like 'a batchfile' do
    let(:batchfile) { processor }
  end

  it_behaves_like 'a purchase_order by product batchfile' do
    let(:po_number) { po_line_item.po_number }
    let(:price_being_updated) { headers.last }
  end

  it 'updates purchase_order product_rrp' do
    expect(po_line_item.supplier_cost_price).to_not eq 20

    contents << [po_line_item.po_number, product.id, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    expect { validate_and_process(batch_file) }.to change { po_line_item.reload.product_rrp }.to(20)
  end

  it 'updates sku price for all skus on the po' do
    expect(skus.map(&:price).include?(20)).to be false

    contents << [po_line_item.po_number, product.id, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    expect { validate_and_process(batch_file) }
      .to change { skus.each(&:reload).map(&:price) }.to [20, 20, 20, 20]
  end
end
