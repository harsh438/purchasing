feature 'Adding a barcode to an existing sku' do
  subject { JSON.parse(page.body) }

  scenario 'Adding Barcode to SKU' do
    when_i_add_a_barcode_to_sku
    then_the_barcode_should_be_listed_under_the_sku
  end

  def when_i_add_a_barcode_to_sku
    attrs = { barcodes_attributes: [{ barcode: '00000' }] }
    page.driver.post sku_path(sku), { _method: 'patch', sku: attrs }
  end

  def then_the_barcode_should_be_listed_under_the_sku
    expect(subject['barcodes'].first).to include('barcode' => '00000')
  end

  let(:sku) { create(:sku) }
end
