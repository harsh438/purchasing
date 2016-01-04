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

  scenario 'Filtering by brand' do
    when_i_filter_skus_by_brand
    then_only_skus_of_that_brand_should_be_listed
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

  def when_i_filter_skus_by_brand
    create_list(:sku, 5)
    vendor = create(:vendor)
    create_list(:sku, 2, vendor: vendor)
    visit skus_path(filters: { vendor_id: vendor.id })
  end

  def then_only_skus_of_that_brand_should_be_listed
    expect(subject['skus'].count).to eq(2)
  end
end
