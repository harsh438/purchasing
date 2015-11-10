feature 'Showing order details' do
  subject { JSON.parse(page.body) }

  scenario 'Listing order line items' do
    when_i_request_order_details
    then_i_should_see_all_line_items
  end

  def when_i_request_order_details
    visit order_path(create(:order, line_item_count: 2))
  end

  def then_i_should_see_all_line_items
    expect(subject['line_items'].count).to eq(2)
  end
end
