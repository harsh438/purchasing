feature 'Listing Skus for the hub' do
  subject { JSON.parse(page.body) }

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

  scenario 'Requesting a really large id should return nothing' do
    when_i_request_a_list_of_skus_with_a_large_id_limit
    then_i_should_get_default_parameters_with_large_id_limit
  end

  def when_i_request_a_list_of_skus
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: 2.years.ago.iso8601,
        last_id: 0
      }
    }
  end

  def then_i_should_have_skus_listed
    request_id_should_be_identical
    expect(subject['skus'].count).to be(20)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_with_a_limit
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 5,
        last_timestamp: Time.now.iso8601,
        last_id: 0
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
        last_timestamp: 30.minutes.ago.iso8601,
        last_id: 0
      }
    }
  end

  def then_i_should_get_a_list_of_skus_within_timestamp
    request_id_should_be_identical
    expect(subject['skus'].count).to be(15)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_with_id_limit
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        limit: 40,
        last_timestamp: Time.now.iso8601,
        last_id: Vendor.first.id
      }
    }
  end

  def then_i_should_get_a_list_of_skus_with_id_limit
    request_id_should_be_identical
    expect(subject['skus'].count).to be(9)
    skus_should_contain_sku_fields
  end

  def when_i_request_a_list_of_skus_with_a_large_id_limit
    create_sku_list
    page.driver.post latest_hub_skus_path, {
      request_id: request_id,
      parameters: {
        last_timestamp: 2.years.ago.iso8601,
        last_id: really_large_id
      }
    }
  end

  def then_i_should_get_default_parameters_with_large_id_limit
    request_id_should_be_identical
    expect(subject['skus'].count).to be(0)
    expect(subject['summary']).to eq("Returned 0 sku objects.")
    expect(subject['parameters']['last_id'].to_i).to eq(really_large_id)
    expect(subject['parameters']['last_timestamp']).to eq(2.years.ago.iso8601)
  end

  def request_id_should_be_identical
    expect(subject['request_id']).to eq(request_id)
  end

  def skus_should_contain_sku_fields
    expect(subject['skus'][0]).to match(a_hash_including('id', 'name', 'category_name'))
  end

  let(:request_id) { Faker::Lorem.characters(15) }
  let(:really_large_id) { 99999999 }

  let(:create_sku_list) do
    create_list(:sku, 10, :without_updated_date)
    create_list(:sku, 5, :with_old_updated_date)
    skus_with_recent_updated_date
    create_list(:sku_without_barcode, 3, :without_updated_date) # these should not show up
  end

  let(:skus_with_recent_updated_date) { create_list(:sku, 5, :with_recent_updated_date) }

end
