feature 'SKU Listing' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of SKU pagination' do
    when_i_request_list_of_skus
    then_i_should_see_paginated_list_of_skus
  end

  scenario 'Filtering by full SKU' do
    when_i_request_a_specific_sku
    then_i_should_only_see_that_sku
  end

  scenario 'Filtering by SKU stem' do
    when_i_request_the_stem_of_a_sku
    then_i_should_see_all_the_skus_sharing_that_stem
  end

  scenario 'Filtering by brand' do
    when_i_filter_skus_by_brand
    then_only_skus_of_that_brand_should_be_listed
  end

  scenario 'Filtering without barcode must contain a season' do
    when_i_filter_skus_without_barcode
    then_a_season_must_be_provided
  end

  scenario 'Filtering without barcode with a season works' do
    when_i_filter_skus_without_barcode_with_a_season
    then_i_should_see_paginated_list_of_skus_without_barcode
  end

  def when_i_request_list_of_skus
    create_list(:base_sku, 52, :with_product, :with_barcode, :sized)
    visit skus_path
  end

  def then_i_should_see_paginated_list_of_skus
    expect(subject['skus'].count).to eq(50)
    expect(subject['skus'].first).to match(a_hash_including('barcodes' => a_kind_of(Array)))
  end

  def when_i_request_a_specific_sku
    skus = create_pair(:base_sku, :with_product, :with_barcode, :sized)
    visit skus_path(filters: { sku: skus.first.sku })
  end

  def then_i_should_only_see_that_sku
    expect(subject['skus'].count).to eq(1)
  end

  def when_i_request_the_stem_of_a_sku
    related_skus = ['123-456', '123-457']
    skus = create_list(:base_sku, 3, :with_product, :with_barcode, :sized)
    related_skus.each_with_index do |sku, index|
      skus[index].update(sku: sku)
    end

    visit skus_path(filters: { sku: '123' })
  end

  def then_i_should_see_all_the_skus_sharing_that_stem
    expect(subject['skus'].count).to eq 2
  end

  def when_i_filter_skus_by_brand
    create_list(:base_sku, 5, :with_product, :with_barcode, :sized)
    vendor = create(:vendor)
    create_list(:base_sku, 2, :with_product, :with_barcode, :sized, vendor: vendor)
    visit skus_path(filters: { vendor_id: vendor.id })
  end

  def then_only_skus_of_that_brand_should_be_listed
    expect(subject['skus'].count).to eq(2)
  end

  def when_i_filter_skus_without_barcode
    visit skus_path(filters: { without_barcodes: '1' })
  end

  def then_a_season_must_be_provided
    expect(page.status_code).to be(422)
    expect(subject['message']).to eq('Season is mandatory if without barcode is selected')
  end

  def when_i_filter_skus_without_barcode_with_a_season
    create_list(:base_sku, 5, :sized, season: Season.find_by(SeasonNickname: 'AW15'))
    visit skus_path(filters: {
      without_barcodes: '1',
      season: 'AW15'
    })
  end

  def then_i_should_see_paginated_list_of_skus_without_barcode
    expect(subject['skus'].count).to eq(5)
  end
end
