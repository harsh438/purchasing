RSpec.shared_examples 'a batchfile' do
  it 'is a registered processor' do
    expect(BatchFile.available_processors).to include batchfile.processor_type.constantize
  end

  it 'has a sample file defined' do
    expect(batchfile.processor_type.constantize.sample_file).to include headers
  end

  it 'validates the csv headers' do
    batch_file = build(
      :batch_file,
      processor_type_id: batchfile.id,
      contents: [%w(these headers are wrong)]
    )
    batch_file.save
    expect(batch_file.errors).to include(:headers)
  end

  it 'validates the column count' do
    batch_file = build(
      :batch_file,
      processor_type_id: batchfile.id,
      contents: [[]]
    )
    batch_file.save
    expect(batch_file.errors).to include(:column_count)
  end
end
