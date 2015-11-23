feature 'Suppliers CRUD' do
  subject { JSON.parse(page.body) }

  scenario 'Creating a Supplier' do
    page.driver.post suppliers_path(supplier: supplier_attrs)
    expect(subject).to include(supplier_attrs)
  end

  scenario 'Getting a Supplier' do
    @supplier = create(:supplier)
    visit supplier_path(@supplier)
    expect(subject).to include("id" => @supplier.id,
                               "name" => @supplier.name)
  end

  private

  let(:supplier_attrs) do
    attributes_for(:supplier, :with_details).stringify_keys
  end
end
