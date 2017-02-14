require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  include_context 'po batch file context'

  let(:processor) { create(:batch_file_processor) }

  let(:headers) { %w(po sku cost_price) }
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

  it 'updates cost_price' do
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    expect { validate_and_process(batch_file) }.to change {
      purchase_order_line_item.reload.cost
    }.to(20)
  end
end
