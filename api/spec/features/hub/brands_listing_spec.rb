feature 'Listing Brands for the hub' do
  subject { JSON.parse(page.body) }

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

  def when_i_request_a_list_of_brands
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: Time.now.iso8601,
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
      parameters: {
        limit: 5,
        last_timestamp: Time.now.iso8601,
        last_id: 0
      }
    }
  end

  def then_i_should_get_a_list_of_brands_with_that_limit
    request_id_should_be_identical
    expect(subject['brands'].count).to be(5)
    brand_should_contain_brand_fields
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
    expect(subject['brands'].count).to be(15)
    brand_should_contain_brand_fields
  end

  def when_i_request_a_list_of_brands_with_id_limit
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: Time.now.iso8601,
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
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: 20.minutes.ago.iso8601,
        last_id:  brands_with_recent_updated_date.third.id
      }
    }
  end

  def then_i_should_not_get_the_brand_if_its_over_the_limit
    request_id_should_be_identical
    expect(subject['brands'].count).to be(2)
    expect(subject['brands'][0]['id']).to be(brands_with_recent_updated_date[3].id)
    expect(subject['brands'][1]['id']).to be(brands_with_recent_updated_date[4].id)
  end

  def request_id_should_be_identical
    expect(subject['request_id']).to eq(request_id)
  end

  def brand_should_contain_brand_fields
    expect(subject['brands'][0]).to match(a_hash_including('id', 'name'))
  end

  def when_i_request_a_list_of_brands_which_is_not_returning_anything
    create_brands
    page.driver.post latest_hub_brands_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: 20.minutes.ago.iso8601,
        last_id: create_brands.last.id + 1
      }
    }
  end

  def then_i_should_have_valid_data_returned
    request_id_should_be_identical
    expect(subject['brands'].count).to be(0)
    expect(subject['parameters']['last_id'].to_i).to be(create_brands.last.id + 1)
  end

  let(:create_brands) do
    create_list(:vendor, 10, :without_updated_date)
    create_list(:vendor, 5, :with_old_updated_date)
    brands_with_recent_updated_date
  end

  let(:brands_with_recent_updated_date) { create_list(:vendor, 5, :with_recent_updated_date) }

  let(:request_id) { Faker::Lorem.characters(15) }
end
