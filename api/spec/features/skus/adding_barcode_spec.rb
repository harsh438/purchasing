feature 'Adding a barcode to an existing sku' do
  subject { JSON.parse(page.body).with_indifferent_access }

  scenario 'Adding Barcode to SKU' do
    when_i_add_a_barcode_to_sku
    then_the_barcode_should_be_listed_under_the_sku
  end

  scenario 'Creating legacy records' do
    when_i_add_a_barcode_to_a_sku_for_the_first_time
    then_legacy_records_should_be_created_for_the_sku
  end

  def when_i_add_a_barcode_to_sku
    add_barcode_to_sku(create(:sku))
  end

  def then_the_barcode_should_be_listed_under_the_sku
    expect(subject[:barcodes].first).to include('barcode' => '00000')
  end

  def when_i_add_a_barcode_to_a_sku_for_the_first_time
    add_barcode_to_sku(create(:sku_without_barcode))
  end

  def then_legacy_records_should_be_created_for_the_sku
    expect(subject[:product_id]).to_not be(nil)
  end

  private

  def add_barcode_to_sku(sku)
    attrs = { barcodes_attributes: [{ barcode: '00000' }] }
    page.driver.post sku_path(sku), { _method: 'patch', sku: attrs }
  end
end
