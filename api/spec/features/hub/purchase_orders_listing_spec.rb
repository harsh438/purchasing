feature 'Listing Purchase Orders for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'Requesting a list of purchase orders' do
    when_i_request_a_list_of_purchase_orders
    then_i_should_get_purchase_orders_with_line_items
  end

  def when_i_request_a_list_of_purchase_orders
    create_purchase_order_with_line_items
    visit purchase_orders_hub_index_path
  end

  def then_i_should_get_purchase_orders_with_line_items
    expect(subject.count).to be(10)
    expect(subject[0]['purchase_order_line_items'][0]).to match(a_hash_including('status', 'delivery_date'))
  end

  let (:create_purchase_order_with_line_items) do
    create_list(:purchase_order, 10, :with_line_items)
  end
end
