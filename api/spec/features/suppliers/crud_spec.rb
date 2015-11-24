feature 'Suppliers CRUD' do
  subject { JSON.parse(page.body) }

  scenario 'Listing Suppliers' do
    when_i_request_list_of_suppliers
    then_i_should_see_paginated_list_of_suppliers
  end

  scenario 'Creating a Supplier' do
    when_i_create_a_supplier
    then_i_should_be_provided_with_supplier_attributes
  end

  scenario 'Getting a Supplier' do
    when_retrieving_supplier
    then_i_should_be_provided_with_supplier_id_and_name
  end

  def when_i_request_list_of_suppliers
    create_list(:supplier, 52)
    visit suppliers_path
  end

  def then_i_should_see_paginated_list_of_suppliers
    expect(subject['suppliers'].count).to eq(50)
    expect(subject['total_pages']).to eq(2)
    expect(subject['suppliers']).to include(a_hash_including('id', 'name'))
  end

  def when_i_create_a_supplier
    page.driver.post suppliers_path(supplier: supplier_attrs)
  end

  def then_i_should_be_provided_with_supplier_attributes
    expect(subject).to include(supplier_attrs)
  end

  def when_retrieving_supplier
    @supplier = create(:supplier)
    visit supplier_path(@supplier)
  end

  def then_i_should_be_provided_with_supplier_id_and_name
    expect(subject).to include('id' => @supplier.id,
                               'name' => @supplier.name)
  end

  private

  let(:supplier_attrs) do
    attributes_for(:supplier, :with_details).stringify_keys
  end
end
