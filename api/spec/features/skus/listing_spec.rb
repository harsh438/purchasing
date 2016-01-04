feature 'SKU Listing' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of SKU pagination' do
    when_i_request_list_of_skus
    then_i_should_see_paginated_list_of_skus
  end

  def when_i_request_list_of_skus
    create_list(:sku, 52)
    visit skus_path
  end

  def then_i_should_see_paginated_list_of_skus
    expect(subject['skus'].count).to eq(50)
  end
end
