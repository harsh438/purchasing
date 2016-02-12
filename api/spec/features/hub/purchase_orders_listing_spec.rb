feature 'Listing Purchase Orders for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'Requesting a list of purchase orders' do
    when_i_request_a_list_of_purchase_orders
    then_i_should_get_purchase_orders_with_line_items
  end

  def when_i_request_a_list_of_purchase_orders
    create_purchase_order_with_line_items
    page.driver.post latest_hub_purchase_orders_path, {
      parameters: { timestamp_from: Date.yesterday.iso8601, request_id: request_id }
    }
  end

  def then_i_should_get_purchase_orders_with_line_items
    expect(subject['request_id']).to eq(request_id)
    expect(subject['orders'].count).to be(10)
    expect(subject['orders'][0]['purchase_order_line_items'][0]).to match(a_hash_including('status', 'delivery_date'))
  end

  let (:request_id) {
    'gxrjcvvu2h4kppijw04nf3hxvz8dc97w'
  }

  let (:create_purchase_order_with_line_items) do
    create_list(:purchase_order, 10, :with_line_items)
    create_list(:purchase_order, 10, :with_line_items, :with_old_drop_date)
  end
end
