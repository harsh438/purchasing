feature 'Listing Orders' do
  subject { JSON.parse(page.body) }

  scenario 'Listing orders' do
    when_i_request_list_of_orders
    then_i_should_see_paginated_list_of_orders
  end

  scenario 'Filters orders' do
    when_i_request_list_of_only_reorders
    then_i_should_see_only_reorders
  end

  def when_i_request_list_of_orders
    create_list(:order, 55)
    visit orders_path
  end

  def then_i_should_see_paginated_list_of_orders
    expect(subject['orders'].count).to eq(50)
    expect(subject['total_pages']).to eq(2)
    expect(subject['orders']).to include(a_hash_including('status' => 'new'))
  end

  def when_i_request_list_of_only_reorders
    create(:order, order_type: 'reorder')
    create(:order, order_type: 'order')
    visit orders_path(filters: { order_type: 'reorder' })
  end

  def then_i_should_see_only_reorders
    expect(subject['orders'].count).to eq(1)
  end
end
