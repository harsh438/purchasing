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

  scenario 'Avoid creating legacy records more than once' do
    when_i_add_a_barcode_to_a_sku_for_the_second_time
    then_legacy_records_should_not_be_created_for_the_sku
  end

  scenario 'Change internal_sku when adding barcode to sku' do
    when_i_add_a_barcode_to_a_sku_with_temporary_reference
    then_the_internal_sku_and_purchase_orders_should_be_updated
  end

  def when_i_add_a_barcode_to_sku
    add_barcode_to_sku(create(:sku))
  end

  def then_the_barcode_should_be_listed_under_the_sku
    expect(subject[:barcodes].first).to include('barcode' => '00000')
  end

  def when_i_add_a_barcode_to_a_sku_for_the_first_time
    add_barcode_to_sku(sku_without_barcode)
  end

  def then_legacy_records_should_be_created_for_the_sku
    expect(subject[:product_id]).to_not be(nil)
  end

  def when_i_add_a_barcode_to_a_sku_for_the_second_time
    add_barcode_to_sku(sku)
  end

  def then_legacy_records_should_not_be_created_for_the_sku
    expect(subject[:product_id]).to eq(sku.product_id)
  end

  def when_i_add_a_barcode_to_a_sku_with_temporary_reference
    create(:order, line_item_count: 1)
    create(:order, line_item_count: 1)
    Order.first.line_items.first.update!(internal_sku: sku_without_barcode.sku)
    Order.second.line_items.first.update!(internal_sku: sku_without_barcode.sku)

    add_barcode_to_sku(sku_without_barcode)
  end

  def then_the_internal_sku_and_orders_should_be_updated
    old_sku = sku_without_barcode.sku
    expect(subject[:sku]).to_not eq(old_sku)
    expect(Order.first.line_items.first.internal_sku).to_not eq(old_sku)
    expect(Order.second.line_items.first.internal_sku).to_not eq(old_sku)
  end

  private

  let(:sku) { create(:sku) }
  let(:sku_without_barcode) { create(:sku_without_barcode) }

  def add_barcode_to_sku(sku)
    attrs = { barcodes_attributes: [{ barcode: '00000' }] }
    page.driver.post sku_path(sku), { _method: 'patch', sku: attrs }
  end
end
