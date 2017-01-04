require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  include_context 'batch file context'

  let(:headers) { %w(po discount) }
  let(:contents) { [headers] }
  let(:description) { BatchFiles::Processors::UpdatePurchaseOrderCostPriceByPercent::DESCRIPTION }
  let(:po_number) { purchase_order_line_item.po_number }
  let(:processor) do
    create(:batch_file_processor,
      processor_type: 'BatchFiles::Processors::UpdatePurchaseOrderCostPriceByPercent',
      csv_header_row: headers
    )
  end

  it_behaves_like 'a batchfile' do
    let(:batchfile) { processor }
  end

  context 'Valid batch file' do
    before { contents << [po_number, 8.09] }

    it 'creates a new UpdatePurchaseOrderCostPriceBySku batch file' do
      batch_file = create(:batch_file, processor_type_id: processor.id, contents: contents)

      expect { validate_and_process(batch_file) }.to change { BatchFile.count }.from(1).to(2)
      expect(BatchFile.second.description).to eq description
      expect(BatchFile.second.status).to eq 'new'
    end

    it 'calculates the correct cost price for a po based on the % passed in' do
      batch_file = create(:batch_file, processor_type_id: processor.id, contents: contents)
      validate_and_process(batch_file)
      new_cost_price = BatchFileLine.last.contents[-1]

      expect(new_cost_price).to eq 91.91
    end
  end

  context 'Invalid batch file' do
    it 'validates the discount being a number' do
      contents << [po_number, '#3$abc+']

      batch_file = create(:batch_file,
                          processor_type_id: processor.id,
                          contents: contents)

      validate_batch_file(batch_file)

      expect(batch_file.batch_file_lines.last.processor_errors).to include(:discount)
    end

    it 'validates that the PO exists (and has lines)' do
      contents << ['not_a_number', 10]

      batch_file = create(:batch_file,
                          processor_type_id: processor.id,
                          contents: contents)

      validate_batch_file(batch_file)

      expect(batch_file.batch_file_lines.last.processor_errors).to include(:purchase_order_lines)
    end

    it 'if the cost price of the PO is missing, or null' do
      create(:purchase_order_line_item,
       :with_summary,
       sku_id: sku.id,
       po_season: Season.all[5].SeasonNickname,
       po_number: 2001)

      contents << [2001, 10]

      batch_file = create(:batch_file,
                          processor_type_id: processor.id,
                          contents: contents)

      validate_batch_file(batch_file)

      expect(batch_file.batch_file_lines.last.processor_errors).to include(:cost_price)
    end
  end
end
