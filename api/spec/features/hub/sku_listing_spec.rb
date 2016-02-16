feature 'Listing Skus for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'listing Skus for the hub' do
    when_i_request_a_list_of_skus
    then_i_should_have_skus_listed
  end

  def when_i_request_a_list_of_skus
    create_sku_list
    page.driver.post latest_hub_skus_path, { request_id: request_id }
  end

  def then_i_should_have_skus_listed
    expect(subject['request_id']).to eq(request_id)
    expect(subject['skus'].count).to be(5)
    expect(subject['skus'][0]).to match(a_hash_including('id', 'name', 'category_name'))
  end

  let(:request_id) { Faker::Lorem.characters(15) }

  let(:create_sku_list) do
    create_list(:sku, 5)
    create_list(:sku_without_barcode, 3) # these should not show up
  end
end
