feature 'Manage order details' do
  subject { JSON.parse(page.body) }

  scenario 'Listing order line items' do
    when_i_request_order_details
    then_i_should_see_all_line_items
  end

  scenario 'Adding line item to order' do
    given_i_am_building_an_order
    when_i_add_a_new_list_item_to_the_order
    then_i_should_see_the_list_item_under_the_order
  end

  scenario 'Adding line item of negative sku and different size to order' do
    given_i_am_building_an_order
    when_i_add_a_negative_list_item_of_a_different_size_to_the_order
    then_i_should_see_the_negative_sku_in_the_order
  end

  scenario 'Generating POs from order' do
    given_i_have_added_list_items_to_an_order
    when_i_want_to_generate_purchase_orders
    then_my_order_should_be_split_into_purchase_orders_correctly
  end

  def when_i_request_order_details
    visit order_path(create(:order, line_item_count: 2))
  end

  def then_i_should_see_all_line_items
    expect(subject['line_items'].count).to eq(2)
  end

  def given_i_am_building_an_order
  end

  def when_i_add_a_new_list_item_to_the_order
    line_item_attrs = { internal_sku: sku.sku,
                        manufacturer_size: sku.manufacturer_size,
                        season: sku.season,
                        cost: '1',
                        quantity: '1',
                        drop_date: Time.now,
                        discount: '0.0' }

    page.driver.post(order_path(order), _method: 'patch',
                                         order: { line_items_attributes: [line_item_attrs] })
  end

  def then_i_should_see_the_list_item_under_the_order
    expect(subject['line_items']).to include(a_hash_including({ internal_sku: sku.sku,
                                                                cost: '£1.00',
                                                                quantity: 1,
                                                                product_name: sku.product_name,
                                                                discount: '0.0' }.stringify_keys))
  end

  def when_i_add_a_negative_list_item_of_a_different_size_to_the_order
    line_item_attrs = [{ internal_sku: negative_sku.sku,
                         manufacturer_size: negative_sku.manufacturer_size,
                         season: negative_sku.season,
                         cost: '1',
                         quantity: '1',
                         drop_date: Time.now,
                         discount: '0.0' },
                       { internal_sku: negative_sku_of_different_size.sku,
                         season: negative_sku_of_different_size.season,
                         manufacturer_size: negative_sku_of_different_size.manufacturer_size,
                         cost: '1',
                         quantity: '1',
                         drop_date: Time.now,
                         discount: '0.0' }]

    page.driver.post(order_path(itemless_order), _method: 'patch',
                                                 order: { line_items_attributes: line_item_attrs })
  end

  def then_i_should_see_the_negative_sku_in_the_order
    expect(subject['line_items'].first['sku_id']).to_not eq(subject['line_items'].second['sku_id'])
  end

  def given_i_have_added_list_items_to_an_order
  end

  def when_i_want_to_generate_purchase_orders
    page.driver.post(export_orders_path, id: order.id)
  end

  def then_my_order_should_be_split_into_purchase_orders_correctly
    expect(subject.first['status']).to eq('exported')
    expect(subject.first['exports'].count).to be > 0
  end

  private

  let(:product) { create(:product) }
  let(:language_product_option) { create(:language_product_option, pID: product.id) }
  let(:sku) { create(:sku) }
  let(:negative_sku) { create(:sku_without_barcode) }
  let(:negative_sku_of_different_size) { create(:sku_without_barcode, sku: negative_sku.sku,
                                                                      manufacturer_size: :smallish) }
  let(:itemless_order) { create(:order) }
  let(:order) { create(:order, line_item_count: 2) }
end
