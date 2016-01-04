feature 'SKU Listing' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of SKU pagination' do
    when_i_request_list_of_skus
    then_i_should_see_paginated_list_of_skus
  end

  scenario 'Filtering by SKU' do
    when_i_request_a_specific_sku
    then_i_should_only_see_that_sku
  end

  def when_i_request_list_of_skus
    create_list(:sku, 52)
    visit skus_path
  end

  def then_i_should_see_paginated_list_of_skus
    expect(subject['skus'].count).to eq(50)
  end

  def when_i_request_a_specific_sku
    skus = create_list(:sku, 2)
    visit skus_path(filters: { sku: skus.first.sku })
  end

  def then_i_should_only_see_that_sku
    expect(subject['skus'].count).to eq(1)
  end
end
