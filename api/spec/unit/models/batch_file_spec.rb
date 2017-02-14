require 'spec_helper'

describe BatchFile, type: :model, batch_file: true do
  include_context 'po batch file context'
  let(:sku2) do
    create(:base_sku,
           :with_barcode,
           :with_product,
           season: Season.all[5])
  end

  let(:headers) { %w(po sku cost_price) }
  let(:contents) { [headers] }
  let(:user) { create(:user) }
  let(:processor) { create(:batch_file_processor) }

  it 'saves the header row of a csv' do
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents,
                        created_by_id: user.id)
    expect(batch_file.csv_header_row).to eq headers
  end

  it 'validates presence of contents and processor_type' do
    batch_file = BatchFile.create

    expect(batch_file.errors).to include(:contents)
    expect(batch_file.errors).to include(:processor_type_id)
  end

  it 'validates the batch_file_lines' do
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    validate_batch_file(batch_file)

    expect(batch_file.batch_file_lines.count).to eq 1
    expect(batch_file.statuses).to eq ['valid']
  end

  it 'has an invalid status if 1 of the lines are invalid' do
    contents << [purchase_order.po_num, sku.sku, 20]
    contents << [nil, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    validate_batch_file(batch_file)

    expect(batch_file.batch_file_lines.first.status).to eq 'valid'
    expect(batch_file.batch_file_lines.last.status).to eq 'invalid'
    expect(batch_file.statuses.count).to eq 2
  end

  it 'will process only valid batch file lines' do
    contents << [purchase_order.po_num, sku.sku, 20]
    contents << [nil, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    batch_file.process!

    expect(BatchFileLineProcessWorker.jobs.size).to eq 1
  end

  it 'catches validation errors when processesing batch file lines' do
    contents << [purchase_order.po_num, sku.sku, 20]
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    validate_and_process(batch_file)
    batch_file.batch_file_lines.reload
    expect(batch_file.batch_file_lines.first.status).to eq 'success'


    contents << [purchase_order.po_num, 'fake sku', 20]
    batch_file2 = create(:batch_file,
                         processor_type_id: processor.id,
                         contents: contents)
    validate_and_process(batch_file2)

    expect(batch_file2.reload.batch_file_lines.last.status).to eq 'invalid'
    expect(batch_file2.batch_file_lines.last.processor_errors).not_to be nil
  end

  it 'is not processable without validating' do
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    expect(batch_file.process!).to eq false
  end

  it 'is not processable with only invalid lines' do
    contents << [nil, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    expect(batch_file.processable?).to eq false
  end

  it 'is processable with 1 valid line' do
    contents << [purchase_order.po_num, sku.sku, 20]
    contents << [nil, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)

    expect(batch_file.processable?).to eq true
  end

  it 'is not processable when allready processed' do
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_and_process(batch_file)

    expect(batch_file.processable?).to eq false
  end

  it 'is fully_processed when processed' do
    contents << [purchase_order.po_num, sku.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_and_process(batch_file)
    batch_file.remove_instance_variable(:@statuses)

    expect(batch_file.fully_processed?).to eq true
  end

  it 'is is validating when 1 of the items has status pending' do
    contents << [purchase_order.po_num, sku.sku, 20]
    contents << [purchase_order.po_num, sku2.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)

    batch_file.batch_file_lines.last.update(status: 'pending')

    expect(batch_file.validating?).to eq true
  end

  it 'is is processing when 1 of the items has status valid' do
    contents << [purchase_order.po_num, sku.sku, 20]
    contents << [purchase_order.po_num, sku2.sku, 20]
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_and_process(batch_file)
    batch_file.batch_file_lines.last.update_column(:status, 'valid')

    expect(batch_file.processing?).to eq true
  end

  it 'validates csv_column_header using the GeneralCsvValidator' do
    contents = [[purchase_order.po_num, sku.sku, 20], [purchase_order.po_num, sku2.sku, 20]]
    batch_file = BatchFile.create(
      processor_type_id: processor.id,
      contents: contents)

    expect(batch_file.errors).to include(:csv_column_header)
  end

  it 'validates column_count using the GeneralCsvValidator' do
    contents = [[], [purchase_order.po_num, sku.sku]]

    batch_file = BatchFile.create(
      processor_type_id: processor.id,
      contents: contents)
    expect(batch_file.errors).to include(:column_count)
  end
end
