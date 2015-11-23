feature 'Suppliers CRUD' do
  subject { JSON.parse(page.body) }

  scenario 'Creating a Supplier' do
    page.driver.post suppliers_path(supplier: supplier_attrs)
    expect(subject).to include(supplier_attrs)
  end

  private

  let(:supplier_attrs) do
    attributes_for(:supplier, :with_details).stringify_keys
  end
end
