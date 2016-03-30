feature 'Listing Purchase Orders for the hub' do
  def subject
    JSON.parse(page.body)
  end

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

  scenario 'Paging works' do
    when_i_request_a_limited_list_of_purchase_orders
    then_the_paging_should_work
  end

  scenario 'Ignore barcodeless purchase orders' do
    when_a_purchase_order_contains_a_sku_without_barcode
    then_that_purchase_order_should_not_be_exported
  end

  scenario 'Splitting big purchase orders' do
    when_i_request_a_giant_purchase_order
    then_it_should_come_in_multiple_parts
  end

  def when_i_request_a_list_of_purchase_orders
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: a_long_time_ago,
        last_id: 0
      }
    }
  end

  def then_i_should_get_purchase_orders_with_line_items
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(6)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_with_a_limit
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 2,
        last_timestamp: a_long_time_ago,
        last_id: 0
      }
    }
  end

  def then_i_should_have_purchase_orders_listed_with_a_limit
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(2)
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
    expect(subject['purchase_orders'].count).to be(3)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_with_id_limit
    create_purchase_orders
    fixed_date = purchase_orders_with_fixed_date[0].updated_at.iso8601
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: fixed_date,
        last_id: purchase_orders_with_fixed_date.second.id
      }
    }
  end

  def then_i_should_get_a_list_of_purchase_orders_with_id_limit
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(7)
    purchase_orders_should_contain_purchase_orders_fields
  end

  def when_i_request_a_list_of_purchase_orders_with_a_large_id_limit
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: Time.now.iso8601,
        last_id: really_large_id
      }
    }
  end

  def then_i_should_get_default_parameters_with_large_id_limit
    request_id_should_be_identical
    no_objects_should_be_returned
    last_id_should_be(nil)
    timestamp_should_be_recent
  end

  def when_i_request_a_limited_list_of_purchase_orders
    create_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: { limit: 2 }
    }
  end

  def then_the_paging_should_work
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(2)
    expect(subject['parameters']['last_timestamp']).to be(nil)

    request_the_next_page(items: 2)
    expect(subject['purchase_orders'].count).to be(1)
    timestamp_should_roughly_be(Time.now)

    request_the_next_page(items: 2, last_timestamp: a_long_time_ago)
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(2)
    last_id_should_be(purchase_orders_with_old_updated_date[1].id)
    purchase_orders_should_contain_purchase_orders_fields

    request_the_next_page(items: 2)
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(2)
    timestamp_should_roughly_be(purchase_orders_with_recent_updated_date.first.updated_at)
    last_id_should_be(purchase_orders_with_recent_updated_date.first.id)
    purchase_orders_should_contain_purchase_orders_fields

    request_the_next_page(items: 20)
    request_id_should_be_identical
    expect(subject['purchase_orders'].count).to be(2)
    timestamp_should_roughly_be(purchase_orders_with_recent_updated_date.first.updated_at)
    last_id_should_be(purchase_orders_with_recent_updated_date.last.id)
    purchase_orders_should_contain_purchase_orders_fields

    request_the_next_page(items: 1)
    request_id_should_be_identical
    no_objects_should_be_returned
    timestamp_should_roughly_be(Time.now)
    last_id_should_be(nil)
  end

  def when_a_purchase_order_contains_a_sku_without_barcode
    purchase_orders_with_recent_updated_date

    line_item = create(:purchase_order_line_item, :balance,
                                                  sku: create(:sku_without_barcode),
                                                  product_id: 1)
    create(:purchase_order, :with_grn_events,
                            :with_recent_updated_date,
                            line_items: [line_item])

    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        last_timestamp: 2.days.ago,
      },
    }
  end

  def then_that_purchase_order_should_not_be_exported
    expect(subject['purchase_orders'].count).to eq(purchase_orders_with_recent_updated_date.count)
  end

  def when_i_request_a_giant_purchase_order
    create_large_purchase_orders
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: 20,
        last_timestamp: a_long_time_ago,
        last_id: 0
      }
    }
  end

  def then_it_should_come_in_multiple_parts
    purchase_orders = create_large_purchase_orders
    results = subject['purchase_orders']
    expect(results.count).to eq(4)
    expect(results[0]['items'].count).to eq(10)
    expect(results[1]['items'].count).to eq(2)
    expect(results[2]['items'].count).to eq(10)
    expect(results[3]['items'].count).to eq(2)
    expect(results[0]['id']).to eq("#{purchase_orders[0].po_number}_1")
    expect(results[1]['id']).to eq("#{purchase_orders[0].po_number}_2")
    expect(results[2]['id']).to eq("#{purchase_orders[1].po_number}_1")
    expect(results[3]['id']).to eq("#{purchase_orders[1].po_number}_2")
    expect(results[0]['po_number']).to eq(purchase_orders[0].po_number)
    updated_at = purchase_orders[0].updated_at.as_json[0..18]
    expect(results[0]['updated_at'][0..18]).to eq(updated_at)
  end

  private

  def request_the_next_page(params)
    page.driver.post latest_hub_purchase_orders_path, {
      request_id: request_id,
      parameters: {
        limit: params[:items],
        last_id: params[:last_id] || subject['parameters']['last_id'],
        last_timestamp: params[:last_timestamp] || subject['parameters']['last_timestamp'],
      }
    }
  end

  def request_id_should_be_identical
    expect(subject['request_id']).to eq(request_id)
  end

  def no_objects_should_be_returned
    expect(subject['purchase_orders'].count).to be(0)
    expect(subject['summary']).to eq('Returned 0 purchase orders objects.')
  end

  def timestamp_should_be_recent
    expect((Time.parse(subject['parameters']['last_timestamp']) - Time.now).abs < 10).to be(true)
  end

  def last_id_should_be(last_id)
    expect(subject['parameters']['last_id'].to_s).to eq(last_id.to_s)
  end

  def purchase_orders_should_contain_purchase_orders_fields
    expect(subject['purchase_orders'][0]).to match(a_hash_including('supplier_name', 'supplier_id', 'id'))
    expect(subject['purchase_orders'][0]['items'][0]).to match(a_hash_including('sku', 'line_id'))
  end

  def timestamp_should_roughly_be(timestamp)
    maximum_diff = 20.minutes.to_i
    timestamp_returned = subject['parameters']['last_timestamp']
    expect((Time.parse(timestamp_returned) - timestamp).abs).to be < maximum_diff
  end

  let(:request_id) { Faker::Lorem.characters(15) }
  let(:really_large_id) { 9999999999 }
  let(:a_long_time_ago) { 2.years.ago.iso8601 }
  let(:recent_date) { 30.minutes.ago.iso8601 }

  let(:create_large_purchase_orders) do
    PurchaseOrder.no_touching do
      create_list(:purchase_order, 2, :with_lots_of_ready_line_items_with_barcode_and_product,
                                      :with_grn_events,
                                      :with_old_updated_date)
    end
  end

  let(:create_purchase_orders) do
    PurchaseOrder.no_touching do
      purchase_orders_with_old_updated_date
      purchase_orders_with_recent_updated_date
      purchase_orders_with_fixed_date
      purchase_orders_without_date

      # none of these should not be listed
      create_list(:purchase_order, 1, :with_ready_line_items)
      create_list(:purchase_order, 1, :with_ready_line_items, :with_grn_events)
      create_list(:purchase_order, 1, :with_line_items_sent_in_peoplevox, :with_grn_events)
      create_list(:purchase_order, 1, :with_ready_line_items, :with_grn_events, :with_old_updated_date)
      create_list(:purchase_order, 1, :with_ready_line_items, :with_old_updated_date)
      create_list(:purchase_order, 1, :with_ready_line_items_with_barcode, :with_grn_events, :with_recent_updated_date)
    end
  end

  let(:purchase_orders_with_old_updated_date) do
    create_list(:purchase_order, 3, :with_ready_line_items_with_barcode_and_product,
                                    :with_grn_events,
                                    :with_old_updated_date)
  end

  let(:purchase_orders_with_recent_updated_date) do
    create_list(:purchase_order, 3, :with_ready_line_items_with_barcode_and_product,
                                    :with_grn_events,
                                    :with_recent_updated_date)
  end

  let(:purchase_orders_with_fixed_date) do
    create_list(:purchase_order, 3, :with_ready_line_items_with_barcode_and_product,
                                    :with_grn_events,
                                    :with_fixed_updated_date)
  end

  let(:purchase_orders_without_date) do
    create_list(:purchase_order, 3, :with_ready_line_items_with_barcode_and_product,
                                    :with_grn_events,
                                    :without_updated_date)
  end
end
