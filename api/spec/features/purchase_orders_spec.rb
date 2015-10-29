feature 'Listing purchase orders' do
  subject { JSON.parse(page.body) }
  let (:vendor) { create(:vendor) }

  before(:each) do
    create_list(:purchase_order, 20)
    create_list(:purchase_order, 16, :arrived)
    create_list(:purchase_order, 15, vendor: vendor)
  end

  scenario 'Default purchase order list' do
    when_i_visit_the_purchase_orders_route
    then_i_should_see_the_first_page_of_purchase_orders
  end

  scenario 'Pagination of purchase orders' do
    when_i_visit_the_third_page_of_results
    then_i_should_see_one_result
  end

  scenario 'Filtering by vendor' do
    when_i_filter_by_vendor
    then_i_should_see_the_first_page_of_orders_for_that_vendor
  end
end

def when_i_visit_the_purchase_orders_route
  visit '/api/purchase_orders.json'
end

def then_i_should_see_the_first_page_of_purchase_orders
  expect(subject.count).to eq(50)
end

def when_i_filter_by_vendor
  visit "/api/purchase_orders.json?vendor_id=#{vendor.id}"
end

def then_i_should_see_the_first_page_of_orders_for_that_vendor
  expect(subject.count).to eq(15)
end

def when_i_visit_the_third_page_of_results
  visit '/api/purchase_orders.json?page=2'
end

def then_i_should_see_one_result
  expect(subject.count).to eq(1)
end
