feature 'Listing Brands for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'Requesting a list of brands' do
    when_i_request_a_list_of_brands
    then_i_should_get_a_list_of_brands
  end

  def when_i_request_a_list_of_brands
    create_brands
    page.driver.post latest_hub_brands_path, { request_id: request_id }
  end

  def then_i_should_get_a_list_of_brands
    expect(subject['request_id']).to eq(request_id)
    expect(subject['brands'].count).to be(10)
    expect(subject['brands'][0]).to match(a_hash_including('id', 'name'))
  end

  let (:request_id) { Faker::Lorem.characters(15) }

  let (:create_brands) do
    create_list(:vendor, 10)
  end
end
