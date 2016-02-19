feature 'Listing Brands for the hub' do
  def subject
    JSON.parse(page.body)
  end

  scenario 'Requesting a list of brands' do
    when_i_request_a_list_of_brands
    then_i_should_get_a_list_of_brands
  end

  scenario 'Requesting a list of brands with limit' do
    when_i_request_a_list_of_brands_with_a_limit
    then_i_should_get_a_list_of_brands_with_that_limit
  end

  scenario 'Requesting a list of brands with timestamp' do
    when_i_request_a_list_of_brands_within_timestamp
    then_i_should_get_a_list_of_brands_within_timestamp
  end

  scenario 'Requesting a list of brands with id limit' do
    when_i_request_a_list_of_brands_with_id_limit
    then_i_should_get_a_list_of_brands_with_id_limit
  end

  scenario 'The id should superseed the timestamp limit' do
    when_i_request_a_list_of_brands_with_id_limit_and_timestamp
    then_i_should_not_get_the_brand_if_its_over_the_limit
  end

  scenario 'An empty list should not make it crash' do
    when_i_request_a_list_of_brands_which_is_not_returning_anything
    then_i_should_have_valid_data_returned
  end

  scenario 'Updating an existing brand' do
    when_i_update_an_existing_brand_and_request_it
    then_i_should_have_the_updated_brand_only
  end

  def when_i_request_a_list_of_brands
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_id: 0
      }
    }
  end

  def then_i_should_get_a_list_of_brands
    request_id_should_be_identical
    expect(subject['brands'].count).to be(10)
    brand_should_contain_brand_fields
  end

  def when_i_request_a_list_of_brands_with_a_limit
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: { limit: 4, last_id: brands_without_updated_date.first.id - 1 }
    }
  end

  def then_i_should_get_a_list_of_brands_with_that_limit
    request_id_should_be_identical
    expect(subject['brands'].count).to be(4)
    last_id_should_be(brands_without_updated_date[3].id.to_s)
    timestamp_returned_should_be_empty
    brand_should_contain_brand_fields

    then_i_request_the_next_page(items: 4)

    request_id_should_be_identical
    expect(subject['brands'].count).to be(4)
    timestamp_returned_should_be_empty
    brand_should_contain_brand_fields

    then_i_request_the_next_page(items: 4)
    timestamp_should_be_recent
    expect(subject['brands'].count).to be(2)
    brand_should_contain_brand_fields

    then_i_request_the_next_page(items: 4)
    no_objects_should_be_returned
    timestamp_should_be_recent
  end

  def then_i_request_the_next_page(params)
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: params[:items],
        last_id: subject['parameters']['last_id'],
        last_timestamp: subject['parameters']['last_timestamp'],
      }
    }
  end

  def when_i_request_a_list_of_brands_within_timestamp
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: 30.minutes.ago.iso8601,
        last_id: 0
      }
    }
  end

  def then_i_should_get_a_list_of_brands_within_timestamp
    request_id_should_be_identical
    expect(subject['brands'].count).to be(1)
    brand_should_contain_brand_fields
  end

  def when_i_request_a_list_of_brands_with_id_limit
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_id: Vendor.first.id
      }
    }
  end

  def then_i_should_get_a_list_of_brands_with_id_limit
    request_id_should_be_identical
    expect(subject['brands'].count).to be(9)
    brand_should_contain_brand_fields
  end

  def when_i_request_a_list_of_brands_with_id_limit_and_timestamp
    create_brands
    fixed_date = brands_with_fixed_updated_date[0].updated_at.iso8601
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: fixed_date,
        last_id:  brands_with_fixed_updated_date.third.id
      }
    }
  end

  def then_i_should_not_get_the_brand_if_its_over_the_limit
    request_id_should_be_identical
    brands_with_date_count = brands_with_recent_updated_date.count + brands_with_fixed_updated_date.count
    brands_with_date_count -= 3 # to match the last_id sent
    expect(subject['brands'].count).to be(brands_with_date_count)
    expect(subject['brands'][0]['id']).to be(brands_with_fixed_updated_date[3].id)
  end

  def when_i_request_a_list_of_brands_which_is_not_returning_anything
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: 2.days.since.iso8601,
      }
    }
  end

  def then_i_should_have_valid_data_returned
    request_id_should_be_identical
    expect(subject['brands'].count).to be(0)
    expect(subject['parameters']['last_id'].to_i).to be(0)
  end

  def when_i_update_an_existing_brand_and_request_it
    new_vendor
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: Time.now,
      }
    }
  end

  def then_i_should_have_the_updated_brand_only
    request_id_should_be_identical
    expect(subject['brands'].count).to be(1)
    expect(subject['parameters']['last_id'].to_i).to be(new_vendor.id.to_i)
  end

  def request_id_should_be_identical
    expect(subject['request_id']).to eq(request_id)
  end

  def brand_should_contain_brand_fields
    expect(subject['brands'][0]).to match(a_hash_including('id', 'name'))
  end

  def timestamp_returned_should_be_empty
    expect(subject['parameters']['last_timestamp'].to_i).to be(0)
  end

  def timestamp_should_be_recent
    expect((Time.parse(subject['parameters']['last_timestamp']) - Time.now).abs < 10).to be(true)
  end

  def last_id_should_be(last_id)
    expect(subject['parameters']['last_id'].to_s).to eq(last_id.to_s)
  end

  def no_objects_should_be_returned
    expect(subject['brands'].count).to be(0)
  end

  let(:new_vendor) { create(:vendor) }

  let(:create_brands) do
    brands_without_updated_date
    create_list(:vendor, 5, :with_old_updated_date)
    brands_with_recent_updated_date
    brands_with_fixed_updated_date
  end

  let(:brands_with_recent_updated_date) do
    create_list(:vendor, 1, :with_recent_updated_date)
  end

  let(:brands_without_updated_date) { create_list(:vendor, 10, :without_updated_date) }
  let(:brands_with_fixed_updated_date) { create_list(:vendor, 5, :with_fixed_updated_date) }

  let(:request_id) { Faker::Lorem.characters(15) }
end
