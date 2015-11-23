feature 'Listing purchase orders' do
  subject { JSON.parse(page.body) }
  let (:vendor) { create(:vendor) }

  before(:each) do
    create_purchase_orders
  end

  scenario 'Default purchase order list' do
    given_there_are_many_pages_of_purchase_orders
    when_i_visit_the_purchase_orders_route
    then_i_should_see_the_first_page_of_purchase_orders
  end

  scenario 'Pagination of purchase orders' do
    given_there_are_many_pages_of_purchase_orders
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

  def given_there_are_many_pages_of_purchase_orders
    create_list(:purchase_order_line_item,
                150,
                :with_summary,
                status: 4,
                season: 'AW15',
                delivery_date: Time.new(2013, 1, 1))
  end

  def when_i_visit_the_purchase_orders_route
    visit purchase_order_line_items_path
  end

  def then_i_should_see_the_first_page_of_purchase_orders
    expect(subject['results'].count).to eq(200)
  end

  def when_i_filter_by_vendor
    visit purchase_order_line_items_path(vendor_id: vendor)
  end

  def then_i_should_see_the_first_page_of_orders_for_that_vendor
    expect(subject['results'].count).to eq(15)
  end

  def when_i_visit_the_third_page_of_results
    visit purchase_order_line_items_path(page: 2)
  end

  def then_i_should_see_one_result
    expect(subject['results'].count).to eq(1)
  end

  def when_i_filter_by_status
    visit purchase_order_line_items_path(status: [:balance])
  end

  def then_i_should_see_the_first_page_of_orders_with_that_status
    expect(subject['results'].count).to eq(20)
  end

  def when_i_filter_by_multiple_statuses
    visit purchase_order_line_items_path(status: [:balance, :cancelled])
  end

  def then_i_should_see_the_first_page_of_orders_with_those_statuses
    expect(subject['results'].count).to eq(35)
  end

  def when_i_filter_by_season
    visit purchase_order_line_items_path(season: :AW15)
  end

  def then_i_should_see_the_first_page_of_orders_for_that_season
    expect(subject['results'].count).to eq(20)
  end

  def when_i_filter_by_date_from
    visit purchase_order_line_items_path(date_from: '2012-01-01')
  end

  def then_i_should_see_the_first_page_of_orders_after_that_date
    expect(subject['results'].count).to eq(35)
  end

  private

  def create_purchase_orders
    create_list(:purchase_order_line_item,
                20,
                :with_summary,
                status: 4,
                season: 'AW15',
                delivery_date: Time.new(2013, 1, 1))

    create_list(:purchase_order_line_item,
                16,
                :with_summary,
                :arrived,
                status: 5,
                season: 'SS14',
                delivery_date: Time.new(2011, 1, 1))

    create_list(:purchase_order_line_item,
                15,
                :with_summary,
                vendor: vendor,
                status: -1,
                season: 'SS15',
                delivery_date: Time.new(2014, 1, 1))
  end
end
