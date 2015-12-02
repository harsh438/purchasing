feature 'Vendors Listing' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of Vendors pagination' do
    when_i_request_list_of_vendors
    then_i_should_see_paginated_list_of_vendors
  end

  scenario 'Filtering Vendors by name' do
    when_i_filter_vendors_by_name
    then_only_vendors_whose_name_matches_should_be_listed
  end

  scenario 'Filtering Vendors by supplier' do
    when_i_filter_vendors_by_supplier
    then_only_vendors_of_that_supplier_should_be_listed
  end

  scenario 'Listing Suppliers that are discontinued' do
    when_i_request_discontinued_suppliers
    then_only_suppliers_that_are_discontinued_should_be_listed
  end

  def when_i_request_list_of_vendors
    create_list(:vendor, 52)
    visit vendors_path
  end

  def then_i_should_see_paginated_list_of_vendors
    expect(subject['vendors'].count).to eq(50)
    expect(subject['total_pages']).to eq(2)
    expect(subject['vendors']).to include(a_hash_including('id', 'name', 'discontinued'))
  end

  def when_i_filter_vendors_by_name
    create_list(:vendor, 10)
    create_list(:vendor, 2, name: 'Luke Clothing Supplies')
    create_list(:vendor, 2, name: 'Supplies by Luke')
    visit vendors_path(filters: { name: 'Luke' })
  end

  def then_only_vendors_whose_name_matches_should_be_listed
    expect(subject['vendors'].count).to eq(4)
  end

  def when_i_filter_vendors_by_supplier
    create_list(:vendor, 5)
    supplier = create(:supplier)
    create_list(:vendor, 2, suppliers: [supplier])
    visit vendors_path(filters: { supplier_id: supplier.id })
  end

  def then_only_vendors_of_that_supplier_should_be_listed
    expect(subject['vendors'].count).to eq(2)
  end

  def when_i_request_discontinued_suppliers
    vendors = create_list(:vendor, 2)
    vendors.first.details.update!(discontinued: true)
    visit vendors_path(filters: { discontinued: '1' })
  end

  def then_only_suppliers_that_are_discontinued_should_be_listed
    expect(subject['vendors'].count).to eq(1)
  end
end
