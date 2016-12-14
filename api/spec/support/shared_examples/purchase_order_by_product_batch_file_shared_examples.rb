RSpec.shared_examples "a purchase_order by product batchfile" do
  it 'validates existence of purchase order' do
    contents << [100_000_000_0, product.id, 20]

    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    validate_batch_file(batch_file)

    expect(batch_file.batch_file_lines.last.processor_errors).to include(:purchase_order)
  end

  it 'validates existence of a product in a purchase order' do
    contents << [po_number, 15000, 20]

    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    validate_batch_file(batch_file)

    expect(batch_file.batch_file_lines.last.processor_errors).to include(:purchase_order_product)
  end

  it "validates that the price being updated is a number " do
    contents << [po_number, product.id, 'notanumber']

    batch_file = create(:batch_file,
                        processor_type_id: processor.id,
                        contents: contents)

    validate_batch_file(batch_file)

    expect(batch_file.batch_file_lines.last.processor_errors).to include(price_being_updated.to_sym)
  end
end
