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
    when_i_visit_the_last_page_of_results
    then_i_should_see_the_last_results
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

  scenario 'Filtering by balance status' do
    given_there_is_a_purchase_order_with_a_balance_status_but_no_outstanding_items
    when_i_filter_by_balance_status
    then_i_should_not_see_orders_with_a_zero_balance
  end

  scenario 'Partial SKU search' do
    when_i_filter_by_partial_sku
    then_i_should_see_orders_with_a_similar_sku
  end

  scenario 'Filtering by PO Number' do
    when_i_filter_by_po_number
    then_i_should_see_the_first_page_of_line_items_for_that_po_number
  end

  def given_there_are_many_pages_of_purchase_orders
    create_list(:purchase_order_line_item,
                250,
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
    expect(subject['results'].first['sku_id']).to_not be_nil
  end

  def when_i_filter_by_vendor
    visit purchase_order_line_items_path(vendor_id: vendor)
  end

  def then_i_should_see_the_first_page_of_orders_for_that_vendor
    expect(subject['results'].count).to eq(3)
  end

  def when_i_visit_the_last_page_of_results
    visit purchase_order_line_items_path(page: 2)
  end

  def then_i_should_see_the_last_results
    expect(subject['results'].count).to eq(65)
  end

  def when_i_filter_by_status
    visit purchase_order_line_items_path(status: [:balance])
  end

  def then_i_should_see_the_first_page_of_orders_with_that_status
    expect(subject['results'].count).to eq(7)
  end

  def when_i_filter_by_multiple_statuses
    visit purchase_order_line_items_path(status: [:balance, :cancelled])
  end

  def then_i_should_see_the_first_page_of_orders_with_those_statuses
    expect(subject['results'].count).to eq(10)
  end

  def when_i_filter_by_season
    visit purchase_order_line_items_path(season: :AW15)
  end

  def then_i_should_see_the_first_page_of_orders_for_that_season
    expect(subject['results'].count).to eq(7)
  end

  def when_i_filter_by_date_from
    visit purchase_order_line_items_path(date_from: '2012-01-01')
  end

  def then_i_should_see_the_first_page_of_orders_after_that_date
    expect(subject['results'].count).to eq(10)
  end

  def given_there_is_a_purchase_order_with_a_balance_status_but_no_outstanding_items
    @po_with_strange_state = create(:purchase_order_line_item,
                                    :with_summary,
                                    status: 4,
                                    quantity: 5,
                                    quantity_done: 5)
  end

  def when_i_filter_by_balance_status
    visit purchase_order_line_items_path(status: [:balance])
  end

  def then_i_should_not_see_orders_with_a_zero_balance
    po = subject['results'].select { |h| h['id'] == @po_with_strange_state.id }
    expect(po.count).to be(0)
  end

  def when_i_filter_by_partial_sku
    partial_sku = PurchaseOrderLineItem.first.product_sku.first(5)
    visit purchase_order_line_items_path(product_sku: partial_sku)
  end

  def then_i_should_see_orders_with_a_similar_sku
    first_product = PurchaseOrderLineItem.first
    product_in_results = subject['results'].select { |h| h['id'] == first_product.id }
    expect(product_in_results).to_not be_nil
  end

  def when_i_filter_by_po_number
    create_purchase_orders
    po_line_item = create(:purchase_order_line_item, :with_summary, status: 4)
    visit purchase_order_line_items_path(po_number: po_line_item.po_number)
  end

  def then_i_should_see_the_first_page_of_line_items_for_that_po_number
    expect(subject['results'].count).to eq(1)
  end

  private

  def create_purchase_orders
    create_list(:purchase_order_line_item,
                7,
                :with_summary,
                :balance,
                season: 'AW15',
                delivery_date: Time.new(2013, 1, 1))

    create_list(:purchase_order_line_item,
                5,
                :with_summary,
                :arrived,
                status: 5,
                season: 'SS14',
                delivery_date: Time.new(2011, 1, 1))

    create_list(:purchase_order_line_item,
                3,
                :with_summary,
                vendor: vendor,
                status: -1,
                season: 'SS15',
                delivery_date: Time.new(2014, 1, 1))
  end
end
