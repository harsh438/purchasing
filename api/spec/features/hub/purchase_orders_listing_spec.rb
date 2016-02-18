feature 'Listing Purchase Orders for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'Requesting a list of purchase orders' do
    when_i_request_a_list_of_purchase_orders
    then_i_should_get_purchase_orders_with_line_items
  end

  scenario 'Requesting a list of purchase orders with a limit' do
    when_i_request_a_list_of_purchase_orders_with_a_limit
    then_i_should_have_purchase_orders_listed_with_a_limit
  end

  scenario 'Requesting a list of purchase orders with timestamp' do
    when_i_request_a_list_of_purchase_orders_within_timestamp
    then_i_should_get_a_list_of_purchase_orders_within_timestamp
  end

  scenario 'Requesting a list of purchase orders with id limit' do
    when_i_request_a_list_of_purchase_orders_with_id_limit
    then_i_should_get_a_list_of_purchase_orders_with_id_limit
  end

  scenario 'Requesting a really large id should return nothing' do
    when_i_request_a_list_of_purchase_orders_with_a_large_id_limit
    then_i_should_get_default_parameters_with_large_id_limit
  end

  def when_i_request_a_list_of_purchase_orders
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: really_old_date,
        last_id: 0
      }
    }
  end

  def then_i_should_get_purchase_orders_with_line_items
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(20)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_with_a_limit
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 10,
        last_timestamp: really_old_date,
        last_id: 0
      }
    }
  end

  def then_i_should_have_purchase_orders_listed_with_a_limit
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(10)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_within_timestamp
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: recent_date,
        last_id: 0
      }
    }
  end

  def then_i_should_get_a_list_of_purchase_orders_within_timestamp
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(15)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_with_id_limit
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: Time.now.iso8601,
        last_id: recent_valid_purchase_orders.first.id
      }
    }
  end

  def then_i_should_get_a_list_of_purchase_orders_with_id_limit
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(9)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_with_a_large_id_limit
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: really_old_date,
        last_id: really_large_id
      }
    }
  end

  def then_i_should_get_default_parameters_with_large_id_limit
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(0)
    expect(subject['summary']).to eq("Returned 0 purchase orders objects.")
    expect(subject['parameters']['last_id'].to_i).to eq(really_large_id)
    expect(subject['parameters']['last_timestamp']).to eq(really_old_date)
  end

  def request_id_should_be_identical
    expect(subject['request_id']).to eq(request_id)
  end

  def purchase_orders_should_contain_purchase_orders_fields
    expect(subject['purchase_orders'][0]).to match(a_hash_including('supplier_name', 'supplier_id', 'id'))
    expect(subject['purchase_orders'][0]['items'][0]).to match(a_hash_including('sku', 'line_id'))
  end

  let (:request_id) { Faker::Lorem.characters(15) }
  let(:really_large_id) { 9999999999 }
  let(:really_old_date) { 2.years.ago.iso8601 }
  let(:recent_date) { 30.minutes.ago.iso8601 }

  let (:create_purchase_orders) do
    recent_valid_purchase_orders
    create_list(:purchase_order, 5, :with_line_items_with_barcode, :with_grn_events, :with_old_updated_date)
    create_list(:purchase_order, 5, :with_line_items_with_barcode, :with_grn_events, :with_recent_updated_date)

    # none of these should not be listed
    create_list(:purchase_order, 1, :with_line_items)
    create_list(:purchase_order, 2, :with_line_items, :with_grn_events)
    create_list(:purchase_order, 3, :with_line_items_sent_in_peoplevox, :with_grn_events)
    create_list(:purchase_order, 4, :with_line_items, :with_grn_events, :with_old_updated_date)
    create_list(:purchase_order, 5, :with_line_items, :with_old_updated_date)
  end

  let(:recent_valid_purchase_orders) do
    create_list(:purchase_order, 10, :with_line_items_with_barcode, :with_grn_events, :without_updated_date)
  end
end
