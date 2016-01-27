feature 'Batch importing Barcodes' do
  subject { JSON.parse(page.body) }

  scenario 'Importing new barcodes' do
    when_i_batch_import_several_barcodes
    then_those_barcodes_should_be_associated_with_skus_of_the_correct_size
  end

  scenario 'Importing barcodes for SKUs that do not exist' do
    when_i_batch_import_several_barcodes_including_one_for_nonexistant_sku
    then_no_barcodes_should_be_imported
  end

  scenario 'Importing barcodes already associate with the same SKU' do
    when_i_batch_import_barcodes_already_associated_with_the_same_skus
    then_already_imported_barcodes_should_be_returned
  end

  scenario 'Importing barcodes already associated with other SKUs' do
    when_i_batch_import_barcodes_already_associated_with_skus
    then_already_imported_barcodes_should_be_associated
  end

  scenario 'Importing barcodes for SKU twice in one import' do
    when_i_batch_import_the_same_barcode_twice_in_one_import
    then_the_barcode_should_be_associated_once
  end

  def when_i_batch_import_several_barcodes
    barcodes = [{ sku: skus.first.sku,
                  brand_size: skus.first.manufacturer_size,
                  barcode: 'new' },
                { sku: skus.third.sku,
                  brand_size: skus.third.manufacturer_size,
                  barcode: 'new2' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_those_barcodes_should_be_associated_with_skus_of_the_correct_size
    expect(subject.first['barcode']).to eq('new')
    expect(subject.first['sku_id']).to eq(skus.first.id)
    expect(subject.second['barcode']).to eq('new2')
    expect(subject.second['sku_id']).to eq(skus.third.id)
  end

  def when_i_batch_import_several_barcodes_including_one_for_nonexistant_sku
    barcodes = [{ sku: skus.first.sku,
                  brand_size: skus.first.manufacturer_size,
                  barcode: 'new' },
                { sku: skus.second.sku,
                  brand_size: skus.second.manufacturer_size,
                  barcode: 'new2' },
                { sku: 'nope',
                  brand_size: 'derk',
                  barcode: 'new3' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_no_barcodes_should_be_imported
    expect(subject['errors']).to_not be_nil
    expect(subject['nonexistant_skus'].count).to eq(1)
  end

  def when_i_batch_import_barcodes_already_associated_with_the_same_skus
    sku = create(:sku, barcodes: [barcode])
    barcodes = [{ sku: sku.sku,
                  brand_size: sku.manufacturer_size,
                  barcode: barcode.barcode }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_already_imported_barcodes_should_be_returned
    expect(subject.count).to eq(1)
  end

  def when_i_batch_import_barcodes_already_associated_with_skus
    create(:sku, barcodes: [barcode])
    barcodes = [{ sku: skus.first.sku,
                  brand_size: skus.first.manufacturer_size,
                  barcode: barcode.barcode }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_already_imported_barcodes_should_be_associated
    expect(subject.count).to eq(1)
  end

  def when_i_batch_import_the_same_barcode_twice_in_one_import
    barcodes = [{ sku: negative_sku.sku,
                  brand_size: negative_sku.manufacturer_size,
                  barcode: 'cool' },
                { sku: negative_sku.sku,
                  brand_size: negative_sku.manufacturer_size,
                  barcode: 'cool' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_the_barcode_should_be_associated_once
    expect(subject.first).to include('barcode' => 'cool')
    expect(subject.count).to eq(1)
  end

  let(:skus) do
    [create(:sku),
     create(:sku_without_barcode, sku: '-bob-small', manufacturer_size: 'small'),
     create(:sku_without_barcode, sku: '-bob-large', manufacturer_size: 'large')]
  end

  let(:negative_sku) { create(:sku_without_barcode) }

  let(:barcode) { create(:barcode, barcode: 'cool') }
end
