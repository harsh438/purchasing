feature 'Batch importing Barcodes' do
  subject { JSON.parse(page.body) }

  scenario 'Importing new barcodes' do
    when_i_batch_import_several_barcodes
    then_those_barcodes_should_be_associated_with_skus
  end

  def when_i_batch_import_several_barcodes
    barcodes = [{ sku: skus.first.sku, barcode: 'new' },
                { sku: skus.second.sku, barcode: 'new2' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_those_barcodes_should_be_associated_with_skus
    expect(subject.first['barcode']).to eq('new')
    expect(subject.second['barcode']).to eq('new2')
  end

  let(:skus) { create_list(:sku, 2) }
end
