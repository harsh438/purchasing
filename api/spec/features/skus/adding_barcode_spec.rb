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

  scenario 'Change internal_sku when adding barcode to SKU' do
    when_i_add_a_barcode_to_a_sku_with_temporary_reference
    then_the_internal_sku_and_orders_should_be_updated
  end

  scenario 'Update legacy references in purchase orders when adding barcode to SKU' do
    when_i_add_a_barcode_to_a_negative_referenced_sku
    then_the_legacy_references_in_purchase_orders_should_be_updated
  end

  scenario 'Add barcode to SKU already associated to another SKU' do
    when_adding_barcode_to_sku_already_associated_with_another_sku
    then_the_new_sku_should_be_linked_to_existing_legacy_records
  end

  def when_i_add_a_barcode_to_sku
    add_barcode_to_sku(sku_without_barcode)
  end

  def then_the_barcode_should_be_listed_under_the_sku
    expect(subject[:barcodes].last).to include('barcode' => '00000')
  end

  def when_i_add_a_barcode_to_a_sku_for_the_first_time
    add_barcode_to_sku(sku_without_barcode)
  end

  def then_legacy_records_should_be_created_for_the_sku
    expect(subject[:product_id]).to_not be(nil)
    expected_cat_name = ProductCategory.find_by(
      product_id: subject[:product_id]
    ).category.language_categories.first.name
    expect(subject[:category_name]).to eq(expected_cat_name)
    expect(Product.find(subject[:product_id]).listing_genders).to eq('M')
  end

  def when_i_add_a_barcode_to_a_sku_for_the_second_time
    add_barcode_to_sku(sku)
  end

  def then_legacy_records_should_not_be_created_for_the_sku
    expect(subject[:product_id]).to eq(sku.product_id)
  end

  def when_i_add_a_barcode_to_a_sku_with_temporary_reference
    order_line_1
    order_line_2
    add_barcode_to_sku(sku_without_barcode)
  end

  def then_the_internal_sku_and_orders_should_be_updated
    old_sku = sku_without_barcode.sku
    expect(subject[:sku]).to_not eq(old_sku)
    expect(order_line_1.reload.internal_sku).to_not eq(old_sku)
  end

  def when_i_add_a_barcode_to_a_negative_referenced_sku
    negative_po_line
    add_barcode_to_sku(negative_sku)
  end

  def then_the_legacy_references_in_purchase_orders_should_be_updated
    expect(negative_po_line.reload.product).to be_a(Product)
    expect(negative_po_line.reload.product).to eq(negative_sku.reload.product)
  end

  def when_adding_barcode_to_sku_already_associated_with_another_sku
    add_barcode_to_sku(sku_without_barcode_with_pid, sku.barcodes.first.barcode)
  end

  def then_the_new_sku_should_be_linked_to_existing_legacy_records
    expect(subject[:product_id]).to eq(existing_product.id)
    expect(subject[:option_id]).not_to eq(nil)
    expect(subject[:language_product_id]).not_to eq(nil)
    expect(subject[:id]).to eq(sku_without_barcode_with_pid.id)
    expect(subject[:product_name]).to eq(sku_without_barcode_with_pid.product_name)
  end

  private

  let(:sku) { create(:base_sku, :sized, :with_product, :with_barcode) }
  let(:sku_without_barcode) { create(:base_sku, :sized) }
  let(:negative_sku) { create(:base_sku, :sized, sku: 'NEGATIVE-TEST') }
  let(:negative_po_line) { create(:purchase_order_line_item, sku: negative_sku) }
  let(:order_line_1) { create(:order_line_item, sku: sku_without_barcode) }
  let(:order_line_2) { create(:order_line_item, sku: sku_without_barcode) }

  let(:existing_product) { create(:product) }
  let(:sku_without_barcode_with_pid) do
    create(:base_sku, :sized, :with_product, product: existing_product)
  end

  def add_barcode_to_sku(sku, barcode = '00000')
    attrs = { barcodes_attributes: [{ barcode: barcode }] }
    VCR.use_cassette 'adding_barcode_spec' do
      page.driver.post sku_path(sku), { _method: 'patch', sku: attrs }
    end
  end
end
