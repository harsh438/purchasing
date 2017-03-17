require 'spec_helper'

RSpec.describe BatchFile, type: :model, batch_file: true do
  include_context 'po batch file context'

  let(:headers) { %w(po dropdate) }
  let(:contents) { [headers] }
  let(:processor) do
    create(:batch_file_processor,
           processor_type: 'BatchFiles::Processors::UpdatePurchaseOrderDropDate',
           csv_header_row: headers)
  end

  before do
    purchase_order.line_items.each { |line_item| line_item.update_attributes(status: 2) }
  end

  it_behaves_like 'a batchfile' do
    let(:batchfile) { processor }
  end

  context 'valid batchfile' do
    it 'updates the drop date of each po_line to the given drop date' do
      contents << [purchase_order.po_num, '31/12/3033']
      created_validated_processed_batch_file(contents)

      drop_dates = purchase_order.reload.line_items.reload.map { |item| item.drop_date.to_s }
      expect(drop_dates.all? { |drop_date| drop_date == '31/12/3033' }).to be_true
    end

    it 'updates the drop date in the po_summary table' do
      contents << [purchase_order.po_num, '31/12/3033']
      created_validated_processed_batch_file(contents)
      expect(purchase_order.reload.drop_date.to_s).to eq '31/12/3033'
    end

    it 'will change a drop date for a po that has been part cancelled' do
      purchase_order.line_items.create(
        attributes_for(:purchase_order_line_item)
      )
      purchase_order.line_items.first.update_attributes!(status: -1)

      contents << [purchase_order.po_num, '31/12/3033']
      batch_file = created_validated_batch_file(contents)
      expect(batch_file.batch_file_lines.last.processor_errors).to include(:purchase_order)
    end
  end

  context 'validations' do
    it 'validates po exists' do
      contents << ['not-a-po', '31/12/3033']
      batch_file = created_validated_batch_file(contents)
      expect(batch_file.batch_file_lines.last.processor_errors).to include(:purchase_order)
    end

    it 'wont change a drop date for a po that has been received' do
      purchase_order.line_items.each { |line_item| line_item.update_attributes!(status: 5) }
      contents << [purchase_order.po_num, '31/12/3033']
      batch_file = created_validated_batch_file(contents)
      expect(batch_file.batch_file_lines.last.processor_errors).to include(:purchase_order)
    end

    context 'date validations' do
      it 'wont accept a drop date that\'s not numeric' do
        contents << [purchase_order.po_num, 'not-a-date']
        batch_file = created_validated_batch_file(contents)
        expect(batch_file.batch_file_lines.last.processor_errors).to include(:drop_date)
      end

      it 'wont accept a day larger than 31' do
        contents << [purchase_order.po_num, '32/12/3033']
        batch_file = created_validated_batch_file(contents)
        expect(batch_file.batch_file_lines.last.processor_errors).to include(:drop_date)
      end

      it 'wont accept a day smaller than one' do
        contents << [purchase_order.po_num, '0/12/3033']
        batch_file = created_validated_batch_file(contents)
        expect(batch_file.batch_file_lines.last.processor_errors).to include(:drop_date)
      end

      it 'wont accept a month larger than 12' do
        contents << [purchase_order.po_num, '31/13/3033']
        batch_file = created_validated_batch_file(contents)
        expect(batch_file.batch_file_lines.last.processor_errors).to include(:drop_date)
      end

      it 'wont accept a month smaller than 1' do
        contents << [purchase_order.po_num, '31/0/3033']
        batch_file = created_validated_batch_file(contents)
        expect(batch_file.batch_file_lines.last.processor_errors).to include(:drop_date)
      end

      it 'wont accept a date before the current date' do
        contents << [purchase_order.po_num, '31/12/1979']
        batch_file = created_validated_batch_file(contents)
        expect(batch_file.batch_file_lines.last.processor_errors).to include(:drop_date)
      end
    end
  end

  def created_validated_processed_batch_file(contents)
    validate_and_process(
      create(:batch_file,
             processor_type_id: processor.id,
             contents: contents)
    )
  end

  def created_validated_batch_file(contents)
    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)
    validate_batch_file(batch_file)
    batch_file
  end
end
