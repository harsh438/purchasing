feature 'Listing Orders' do
  subject { JSON.parse(page.body) }

  scenario 'Listing orders' do
    when_i_request_list_of_orders
    then_i_should_see_paginated_list_of_orders
  end

  def when_i_request_list_of_orders
    create_list(:order, 55)
    visit orders_path
  end

  def then_i_should_see_paginated_list_of_orders
    expect(subject.count).to eq(50)
    expect(subject).to include(a_hash_including('status' => 'new'))
  end
end
