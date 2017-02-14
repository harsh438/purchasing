require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  include_context 'po batch file context'

  let(:processor) do
    create(:batch_file_processor,
      processor_type: 'BatchFiles::Processors::UpdatePurchaseOrderProductRRPBySku')
  end

  let(:headers) { %w(po sku product_rrp) }
  let(:contents) { [headers] }

  it_behaves_like 'a batchfile' do
    let(:batchfile) { processor }
  end

  it 'validates existence of purchase order' do
    contents << [100_000_000_0, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    errors = batch_file.batch_file_lines.last.processor_errors
    expect(errors).to include(:purchase_order)
  end

  it 'updates product_rrp' do
    contents << [purchase_order.po_num, sku.sku, 50]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    expect { validate_and_process(batch_file) }.to change {
      purchase_order_line_item.reload.product_rrp
    }.to(50)
  end
end
