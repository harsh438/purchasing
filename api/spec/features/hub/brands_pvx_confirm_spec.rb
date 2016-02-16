feature 'Orders PVX confirm API for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'Marking a brand as being sent to PVX' do
    when_i_mark_a_brand_being_sent_to_pvx
    then_it_should_be_removed_of_the_list_of_brands
  end

  def when_i_mark_a_brand_being_sent_to_pvx
    page.driver.post pvx_confirm_hub_brands_path, {
      brand: { id: brand_list[0].id }, request_id: request_id
    }
  end

  def then_it_should_be_removed_of_the_list_of_brands
    page.driver.post latest_hub_brands_path, { request_id: request_id }
    expect(subject['request_id']).to eq(request_id)
    expect(subject['brands'].count).to be(4)
    expect(subject['brands'].map do |brand|
      brand['id']
    end).not_to eq(brand_list[0].id)
  end

  let (:request_id) { Faker::Lorem.characters(15) }

  let (:brand_list) do
    create_list(:vendor, 5)
  end
end
