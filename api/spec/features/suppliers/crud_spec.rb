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

  scenario 'Updating supplier' do
    when_updating_supplier
    then_the_changes_to_the_supplier_should_be_returned
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

  def when_updating_supplier
    page.driver.post(supplier_path(supplier),
                     _method: 'patch',
                     supplier: { name: 'Bob', invoicer_name: 'James' })
  end

  def then_the_changes_to_the_supplier_should_be_returned
    expect(subject).to include('name' => 'Bob', 'invoicer_name' => 'James')
  end

  private

  let(:supplier_attrs) do
    attributes_for(:supplier, :with_detail_attrs).stringify_keys
  end

  let(:supplier) { create(:supplier, :with_details) }
end
