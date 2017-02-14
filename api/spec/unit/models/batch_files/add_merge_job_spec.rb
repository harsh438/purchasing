require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  let(:headers) { %w(season from_internal_sku to_internal_sku barcode) }
  let(:contents) { [headers] }
  let(:processor) do
    create(:batch_file_processor,
      processor_type: 'BatchFiles::Processors::AddMergeJob',
      csv_header_row: headers
    )
  end
  let(:from_barcode) { create(:barcode, barcode: '123456') }
  let(:to_barcode) { create(:barcode, barcode: '123456') }
  let(:season) { create(:season, nickname: 'AW17') }
  let(:from_sku) do
    create(
      :base_sku, :with_product, :sized, :with_barcode, barcode: from_barcode, size: 'XL', season: season
    )
  end
  let(:to_sku) do
    create(
      :base_sku, :with_product, :sized, :with_barcode, barcode: to_barcode, size: 'xl', season: season
    )
  end

  it_behaves_like 'a batchfile' do
    let(:batchfile) { processor }
  end

  context 'valid batch file' do
    let(:batch_file) { BatchFile.first }

    before do
      contents << ['AW17', from_sku.sku, to_sku.sku, '123456']
      create(:batch_file, processor_type_id: processor.id, contents: contents)
    end

    it 'adds a merge job to the merge job table' do
      expect { validate_and_process(batch_file) }.to change { MergeJob.count }.from(0).to(1)
    end

    it 'adds the size for the from_sku' do
      validate_and_process(batch_file)
      expect(MergeJob.first.from_sku_size).to eq 'XL'
    end

    it 'adds the size for the to_sku' do
      validate_and_process(batch_file)
      expect(MergeJob.first.to_sku_size).to eq 'xl'
    end

    it 'completed_at is nil' do
      validate_and_process(batch_file)
      expect(MergeJob.first.completed_at).to be_nil
    end
  end

  context 'invalid batch file' do
    it 'validates the existence of the from_sku' do
      contents << ['AW17', 'not-a-sku', to_sku.sku, '123456']

      batch_file = create(:batch_file,
                          processor_type_id: processor.id,
                          contents: contents)

      validate_batch_file(batch_file)

      expect(batch_file.batch_file_lines.last.processor_errors).to include(:from_sku)
    end

    it 'validates the existence of the to_sku' do
      contents << ['AW17', from_sku.sku, 'not-a-sku', '123456']

      batch_file = create(:batch_file,
                          processor_type_id: processor.id,
                          contents: contents)

      validate_batch_file(batch_file)

      expect(batch_file.batch_file_lines.last.processor_errors).to include(:to_sku)
    end

    it 'validates the existence of the barcode on the skus' do
      contents << ['AW17', from_sku.sku, to_sku.sku, 'not-a-barcode']

      batch_file = create(:batch_file,
                          processor_type_id: processor.id,
                          contents: contents)

      validate_batch_file(batch_file)

      expect(batch_file.batch_file_lines.last.processor_errors).to include(:to_sku)
      expect(batch_file.batch_file_lines.last.processor_errors).to include(:from_sku)
    end
  end
end
