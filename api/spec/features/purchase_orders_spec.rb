feature 'Listing purchase orders' do
  subject { JSON.parse(page.body) }
  let (:vendor) { create(:vendor) }

  before(:each) do
    create_list(:purchase_order, 20,
                status: 4,
                season: 'AW15',
                created_at: Time.new(2013, 1, 1))
    create_list(:purchase_order, 16, :arrived,
                season: 'SS14',
                created_at: Time.new(2011, 1, 1))
    create_list(:purchase_order, 15,
                vendor: vendor,
                status: -1,
                season: 'SS15',
                created_at: Time.new(2014, 1, 1))
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

  scenario 'Filtering by status' do
    when_i_filter_by_status
    then_i_should_see_the_first_page_of_orders_with_that_status
  end

  scenario 'Filtering by multiple statuses' do
    when_i_filter_by_multiple_statuses
    then_i_should_see_the_first_page_of_orders_with_those_statuses
  end

  scenario 'Filtering by season' do
    when_i_filter_by_season
    then_i_should_see_the_first_page_of_orders_for_that_season
  end

  scenario 'Filtering by date' do
    when_i_filter_by_date_from
    then_i_should_see_the_first_page_of_orders_after_that_date
  end
end

def when_i_visit_the_purchase_orders_route
  visit '/api/purchase_orders.json'
end

def then_i_should_see_the_first_page_of_purchase_orders
  expect(subject['results'].count).to eq(50)
end

def when_i_filter_by_vendor
  visit "/api/purchase_orders.json?vendor_id=#{vendor.id}"
end

def then_i_should_see_the_first_page_of_orders_for_that_vendor
  expect(subject['results'].count).to eq(15)
end

def when_i_visit_the_third_page_of_results
  visit '/api/purchase_orders.json?page=2'
end

def then_i_should_see_one_result
  expect(subject['results'].count).to eq(1)
end

def when_i_filter_by_status
  visit '/api/purchase_orders.json?status[]=balance'
end

def then_i_should_see_the_first_page_of_orders_with_that_status
  expect(subject['results'].count).to eq(20)
end

def when_i_filter_by_multiple_statuses
  visit '/api/purchase_orders.json?status[]=balance&status[]=cancelled'
end

def then_i_should_see_the_first_page_of_orders_with_those_statuses
  expect(subject['results'].count).to eq(35)
end

def when_i_filter_by_season
  visit '/api/purchase_orders.json?season=AW15'
end

def then_i_should_see_the_first_page_of_orders_for_that_season
  expect(subject['results'].count).to eq(20)
end

def when_i_filter_by_date_from
  visit '/api/purchase_orders.json?date_from=2012-01-01'
end

def then_i_should_see_the_first_page_of_orders_after_that_date
  expect(subject['results'].count).to eq(35)
end
