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

  scenario 'Imported barcode already exists for the given sku' do
    when_i_batch_import_barcodes_already_associated_with_the_same_skus
    then_already_imported_barcodes_should_be_returned
  end

  scenario 'Imported barcode already exists for a different sku' do
    when_i_batch_import_barcodes_already_associated_with_skus
    then_already_imported_barcodes_should_be_associated
  end

  scenario 'Given sku exists already, and has a different barcode' do
    when_a_sku_exists_already_but_has_a_different_barcode
    then_the_barcode_should_be_updated_to_the_new_one
  end

  scenario 'Importing barcodes for SKU twice in one import' do
    when_i_batch_import_the_same_barcode_twice_in_one_import
    then_the_barcode_should_be_associated_once
  end

  scenario 'Importing barcode with product without color is raising an error' do
    when_i_import_barcode_with_product_without_color
    then_i_should_have_a_color_error
  end

  scenario 'Importing barcodes with invalid characters raises an error' do
    when_i_import_barcodes_with_invalid_characters
    then_an_error_is_returned
  end

  def then_an_error_is_returned
    expect(subject['errors']).to_not be_nil
  end

  def when_i_import_barcodes_with_invalid_characters
    barcodes = [{ sku: skus.first.sku,
                  brand_size: skus.first.manufacturer_size,
                  barcode: '\'invalid' },
                { sku: skus.third.sku,
                  brand_size: skus.third.manufacturer_size,
                  barcode: '"invalid2' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def when_i_import_barcode_with_product_without_color
    barcodes = [{ sku: sku_without_product.sku,
                  brand_size: skus.first.manufacturer_size,
                  barcode: 'new' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_i_should_have_a_color_error
    sku = sku_without_product.sku
    error = "Product of sku #{sku} does not have a color (exported barcode = 'new')"
    expect(subject['errors']['skus'][0]).to include(error)
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
    sku = create(:base_sku, :with_product, barcodes: [barcode])
    barcodes = [{ sku: sku.sku,
                  brand_size: sku.manufacturer_size,
                  barcode: barcode.barcode }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_already_imported_barcodes_should_be_returned
    expect(subject.count).to eq(1)
  end

  def when_i_batch_import_barcodes_already_associated_with_skus
    create(:base_sku, :with_product, barcodes: [barcode])
    sku = create(:base_sku, :with_product, sku: '-123')
    barcodes = [{ sku: sku.sku,
                  brand_size: sku.manufacturer_size,
                  barcode: barcode.barcode }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_already_imported_barcodes_should_be_associated
    expect(subject.count).to eq(1)
  end

  def when_a_sku_exists_already_but_has_a_different_barcode
    existing_sku = create(
      :base_sku,
      :with_product,
      barcodes: [create(:barcode)],
      season: Season.first
    )

    create(
      :base_sku,
      :with_product,
      sku: existing_sku.sku,
      barcodes: [create(:barcode)],
      season: Season.last
    )

    barcodes = [{ sku: existing_sku.sku,
                  brand_size: existing_sku.manufacturer_size,
                  barcode: 'cool' }]
    page.driver.post import_barcodes_path, { _method: 'post', barcodes: barcodes }
  end

  def then_the_barcode_should_be_updated_to_the_new_one
    expect(Barcode.count).to eq 2
    expect(Sku.first.barcodes.count).to eq 1
    expect(Sku.first.barcodes.first.barcode).to eq 'cool'
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
    [create(:base_sku, :with_product),
     create(:base_sku, :sized, sku: '-bob-small', manufacturer_size: 'small'),
     create(:base_sku, :sized, sku: '-bob-large', manufacturer_size: 'large')]
  end

  let(:sku_without_product) do
    create(:base_sku,
      manufacturer_sku: 'non-existent-manufacturer-sku',
      color: nil
    )
  end

  let(:negative_sku) { create(:base_sku, :sized) }

  let(:barcode) { create(:barcode, barcode: 'cool') }
end
