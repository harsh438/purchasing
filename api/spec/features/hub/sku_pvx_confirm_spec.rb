feature 'Hub SKU PVX confirm' do
  subject { JSON.parse(page.body) }

  scenario 'Marking a sku as being sent to PVX' do
    when_i_mark_a_sku_being_sent_to_pvx
    then_it_should_be_removed_of_the_list_of_skus
  end

  def when_i_mark_a_sku_being_sent_to_pvx
    page.driver.post pvx_confirm_hub_skus_path, {
      sku: { id: skus[0].id }, request_id: request_id
    }
  end

  def then_it_should_be_removed_of_the_list_of_skus
    page.driver.post latest_hub_skus_path, { request_id: request_id }
    expect(subject['request_id']).to eq(request_id)
    expect(subject['skus'].count).to be(4)
    expect(subject['skus'].map do |sku|
      sku['id']
    end).not_to eq(skus[0].id)
  end

  let(:request_id) { Faker::Lorem.characters(15) }

  let(:skus) do
    create_list(:sku, 5)
  end
end
