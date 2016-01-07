feature 'Batch importing Barcodes' do
  subject { JSON.parse(page.body) }

  scenario 'Importing new barcodes' do
    when_i_batch_import_several_barcodes
    then_those_barcodes_should_be_associated_with_skus
  end

  scenario 'Importing barcodes for SKUs that do not exist' do
    when_i_batch_import_several_barcodes_including_one_for_nonexistant_sku
    then_only_barcodes_for_existing_skus_should_be_returned
  end

  scenario 'Importing barcodes already associate with the same SKU' do
    when_i_batch_import_barcodes_already_associated_with_the_same_skus
    then_already_imported_barcodes_should_be_returned
  end

  scenario 'Importing barcodes already associated with other SKUs' do
    when_i_batch_import_barcodes_already_associated_with_skus
    then_already_imported_barcodes_should_be_not_be_associated
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

  def when_i_batch_import_several_barcodes_including_one_for_nonexistant_sku
    barcodes = [{ sku: skus.first.sku, barcode: 'new' },
                { sku: 'nope', barcode: 'new2' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_only_barcodes_for_existing_skus_should_be_returned
    expect(subject.count).to eq(1)
  end

  def when_i_batch_import_barcodes_already_associated_with_the_same_skus
    sku = create(:sku, barcodes: [barcode])
    barcodes = [{ sku: sku.sku, barcode: barcode.barcode }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_already_imported_barcodes_should_be_returned
    expect(subject.count).to eq(1)
  end

  def when_i_batch_import_barcodes_already_associated_with_skus
    create(:sku, barcodes: [barcode])
    barcodes = [{ sku: skus.first.sku, barcode: barcode.barcode }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_already_imported_barcodes_should_be_not_be_associated
    expect(subject['error']).to_not be_nil
    expect(subject['duplicate_barcodes'].count).to eq(1)
  end

  let(:skus) { create_list(:sku, 2) }
  let(:barcode) { create(:barcode, barcode: 'cool') }
end
