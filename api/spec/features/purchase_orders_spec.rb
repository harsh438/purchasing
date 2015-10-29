feature 'Listing purchase orders' do
  subject { JSON.parse(page.body) }

  before(:each) do
    create_list(:purchase_order, 85)
    create_list(:purchase_order, 20, :arrived)
  end

  scenario 'Default purchase order list' do
    when_i_visit_the_purchase_orders_route
    i_should_see_the_first_page_of_purchase_orders
  end
end

def when_i_visit_the_purchase_orders_route
  visit '/api/purchase_orders.json'
end

def i_should_see_the_first_page_of_purchase_orders
  expect(subject.count).to eq(50)
end
