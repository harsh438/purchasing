require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  include_context 'batchfile purchase order updates by product'

  let(:headers) { %w(po product_id supplier_cost_price) }
  let(:contents) { [headers] }

  let(:processor) do
    create(:batch_file_processor,
           processor_type: 'BatchFiles::Processors::UpdatePurchaseOrderSupplierCostPrice',
           csv_header_row: headers)
  end

  it_behaves_like 'a batchfile' do
    let(:batchfile) { processor }
  end

  it_behaves_like 'a purchase_order by product batchfile' do
    let(:po_number) { po_line_item.po_number }
    let(:price_being_updated) { headers.last }
  end

  it 'updates supplier_cost_price' do
    expect(po_line_item.supplier_list_price).to_not eq 20

    contents << [po_line_item.po_number, product.id, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    expect { validate_and_process(batch_file) }
      .to change { po_line_item.reload.supplier_list_price }.to(20)
  end
end
