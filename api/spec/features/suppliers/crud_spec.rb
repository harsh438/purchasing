feature 'Suppliers CRUD' do
  subject { JSON.parse(page.body) }

  scenario 'Creating a Supplier' do
    when_i_create_a_supplier
    then_i_should_be_provided_with_supplier_attributes
  end

  scenario 'Getting a Supplier' do
    when_retrieving_supplier
    then_i_should_be_provided_with_supplier_id_and_name
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
                               'name' => @supplier.name,
                               'contacts' => a_kind_of(Array))
  end

  private

  let(:supplier_attrs) do
    attributes_for(:supplier, :with_details).stringify_keys
  end
end
