feature 'Listing Skus for the hub' do
  def subject
    JSON.parse(page.body)
  end

  scenario 'listing Skus for the hub' do
    when_i_request_a_list_of_skus
    then_i_should_have_skus_listed
  end

  scenario 'listing Skus for the hub with a limit' do
    when_i_request_a_list_of_skus_with_a_limit
    then_i_should_have_skus_listed_with_a_limit
  end

  scenario 'Requesting a list of skus with timestamp' do
    when_i_request_a_list_of_skus_within_timestamp
    then_i_should_get_a_list_of_skus_within_timestamp
  end

  scenario 'Requesting a list of skus with id limit' do
    when_i_request_a_list_of_skus_with_id_limit
    then_i_should_get_a_list_of_skus_with_id_limit
  end

  scenario 'An empty list should not make it crash' do
    when_i_request_a_list_of_skus_which_is_not_returning_anything
    then_i_should_have_valid_data_returned
  end

  scenario 'Paging works' do
    when_i_request_a_limited_list_of_skus
    then_the_paging_should_work
  end

  def when_i_request_a_limited_list_of_skus
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: { limit: 4, last_timestamp: a_long_time_ago }
    }
  end

  def then_the_paging_should_work
    request_id_should_be_identical
    expect(subject['skus'].count).to be(4)
    timestamp_should_roughly_be(skus_with_old_updated_date.first.updated_at)
    last_id_should_be(skus_with_old_updated_date[3].id)
    skus_should_contain_sku_fields

    then_i_request_the_next_page(items: 4)
    request_id_should_be_identical
    expect(subject['skus'].count).to be(4)
    timestamp_should_roughly_be(skus_with_recent_updated_date.first.updated_at)

    then_i_request_the_next_page(items: 20)
    request_id_should_be_identical
    expect(subject['skus'].count).to be(7)
    last_id_should_be(skus_with_recent_updated_date.last.id)
    timestamp_should_roughly_be(skus_with_recent_updated_date.first.updated_at)

    then_i_request_the_next_page(items: 20)
    request_id_should_be_identical
    expect(subject['skus'].count).to be(0)
    no_objects_should_be_returned
    timestamp_should_roughly_be(Time.now)
  end

  def then_i_request_the_next_page(params)
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: params[:items],
        last_id: subject['parameters']['last_id'],
        last_timestamp: subject['parameters']['last_timestamp'],
      }
    }
  end

  def when_i_request_a_list_of_skus
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: { limit: 40, last_timestamp: a_long_time_ago }
    }
  end

  def then_i_should_have_skus_listed
    request_id_should_be_identical
    count = skus_with_recent_updated_date.count + skus_with_old_updated_date.count
    expect(subject['skus'].count).to be(count)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_with_a_limit
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 5,
        last_timestamp: recently,
      }
    }
  end

  def then_i_should_have_skus_listed_with_a_limit
    request_id_should_be_identical
    expect(subject['skus'].count).to be(5)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_within_timestamp
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: recently,
        last_id: 0
      }
    }
  end

  def then_i_should_get_a_list_of_skus_within_timestamp
    request_id_should_be_identical
    expect(subject['skus'].count).to be(skus_with_recent_updated_date.count)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_with_id_limit
    create_sku_list
    fixed_date = skus_with_fixed_updated_date.first.updated_at.iso8601
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: fixed_date,
        last_id: skus_with_fixed_updated_date.second.id
      }
    }
  end

  def then_i_should_get_a_list_of_skus_with_id_limit
    request_id_should_be_identical
    count = skus_with_recent_updated_date.count
    count += skus_with_old_updated_date.count
    count += skus_with_fixed_updated_date.count - 2
    expect(subject['skus'].count).to be(count)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_which_is_not_returning_anything
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: in_the_future,
      }
    }
  end

  def then_i_should_have_valid_data_returned
    request_id_should_be_identical
    no_objects_should_be_returned
    last_id_should_be(0)
  end

  def request_id_should_be_identical
    expect(subject['request_id']).to eq(request_id)
  end

  def skus_should_contain_sku_fields
    expect(subject['skus'][0]).to match(a_hash_including('id', 'name', 'category_name'))
  end

  def timestamp_returned_should_be_empty
    expect(subject['parameters']['last_timestamp'].to_i).to be(0)
  end

  def timestamp_returned_should_be_old
    expect(subject['parameters']['last_timestamp'].to_s).to be(a_long_time_ago)
  end

  def timestamp_should_roughly_be(timestamp)
    maximum_diff = 10.minutes.to_i
    timestamp_returned = subject['parameters']['last_timestamp']
    expect((Time.parse(timestamp_returned) - timestamp).abs).to be < maximum_diff
  end

  def last_id_should_be(last_id)
    expect(subject['parameters']['last_id'].to_s).to eq(last_id.to_s)
  end

  def no_objects_should_be_returned
    expect(subject['skus'].count).to be(0)
    expect(subject['summary']).to eq('Returned 0 sku objects.')
  end


  let(:request_id) { Faker::Lorem.characters(15) }
  let(:really_large_id) { 99999999 }

  let(:a_long_time_ago) { 4.years.ago.iso8601 }
  let(:recently) { 30.minutes.ago.iso8601 }
  let(:in_the_future) { 2.days.since.iso8601 }

  let(:create_sku_list) do
    skus_with_recent_updated_date
    skus_with_old_updated_date
    skus_with_fixed_updated_date
    create_list(:sku_without_barcode, 3, :with_old_updated_date) # these should not show up
  end

  let(:skus_with_fixed_updated_date) { create_list(:sku, 5, :with_fixed_updated_date) }
  let(:skus_with_recent_updated_date) { create_list(:sku, 10, :with_recent_updated_date) }
  let(:skus_with_old_updated_date) { create_list(:sku, 5, :with_old_updated_date) }
end
