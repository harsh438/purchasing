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
    @order = create(:order)
  end

  def when_i_add_a_new_list_item_to_the_order
    product = create(:product)
    option = create(:language_product_option, pID: product.id)
    @po_line = create(:purchase_order_line_item, product: product, oID: option.oID)

    line_item_attrs = { internal_sku: @po_line.internal_sku,
                        cost: '1',
                        quantity: '1',
                        drop_date: Time.now,
                        discount: '0.0' }

    page.driver.post(order_path(@order), _method: 'patch',
                                         order: { line_items_attributes: [line_item_attrs] })
  end

  def then_i_should_see_the_list_item_under_the_order
    expect(subject['line_items']).to include(a_hash_including({ internal_sku: @po_line.internal_sku,
                                                                cost: '£1.00',
                                                                quantity: 1,
                                                                discount: '0.0' }.stringify_keys))
  end

  def given_i_have_added_list_items_to_an_order
    @order = create(:order, line_item_count: 2)
  end

  def when_i_want_to_generate_purchase_orders
    page.driver.post(export_orders_path, id: @order.id)
  end

  def then_my_order_should_be_split_into_purchase_orders_correctly
    expect(subject.first['status']).to eq('exported')
    expect(subject.first['exports'].count).to be > 0
  end
end
