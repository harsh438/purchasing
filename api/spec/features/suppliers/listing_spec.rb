feature 'Suppliers CRUD' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of Suppliers pagination' do
    when_i_request_list_of_suppliers
    then_i_should_see_paginated_list_of_suppliers
  end

  scenario 'Filtering Suppliers by name' do
    when_i_filter_suppliers_by_name
    then_only_suppliers_whose_name_matches_should_be_listed
  end

  scenario 'Filtering Suppliers by brand' do
    when_i_filter_suppliers_by_brand
    then_only_suppliers_of_that_brand_should_be_listed
  end

  scenario 'Listing Suppliers that are discontinued' do
    when_i_request_discontinued_suppliers
    then_only_suppliers_that_are_discontinued_should_be_listed
  end

  def when_i_request_list_of_suppliers
    create_list(:supplier, 52)
    visit suppliers_path
  end

  def then_i_should_see_paginated_list_of_suppliers
    expect(subject['suppliers'].count).to eq(50)
    expect(subject['total_pages']).to eq(2)
    expect(subject['suppliers']).to include(a_hash_including('id', 'name', 'contacts'))
  end

  def when_i_filter_suppliers_by_name
    create_list(:supplier, 10)
    create_list(:supplier, 2, name: 'Luke Clothing Supplies')
    create_list(:supplier, 2, name: 'Supplies by Luke')
    visit suppliers_path(filters: { name: 'Luke' })
  end

  def then_only_suppliers_whose_name_matches_should_be_listed
    expect(subject['suppliers'].count).to eq(4)
  end

  def when_i_filter_suppliers_by_brand
    create_list(:supplier, 5)
    vendor = create(:vendor)
    create_list(:supplier, 2, vendors: [vendor])
    visit suppliers_path(filters: { vendor_id: vendor.id })
  end

  def then_only_suppliers_of_that_brand_should_be_listed
    expect(subject['suppliers'].count).to eq(2)
  end

  def when_i_request_discontinued_suppliers
    suppliers = create_list(:supplier, 2)
    suppliers.first.details.update!(discontinued: true)
    visit suppliers_path(filters: { discontinued: '1' })
  end

  def then_only_suppliers_that_are_discontinued_should_be_listed
    expect(subject['suppliers'].count).to eq(1)
  end
end
