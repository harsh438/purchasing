feature 'Vendors CRUD' do
  subject { JSON.parse(page.body) }

  scenario 'Creating a vendor' do
    when_i_create_a_vendor
    then_i_should_be_provided_with_vendor_attributes
  end

  scenario 'Getting a vendor' do
    when_retrieving_vendor
    then_i_should_be_provided_with_vendor_id_and_name
  end

  def when_i_create_a_vendor
    page.driver.post vendors_path(vendor: vendor_attrs)
  end

  def then_i_should_be_provided_with_vendor_attributes
    expect(subject).to include(vendor_attrs)
  end

  def when_retrieving_vendor
    @vendor = create(:vendor)
    visit vendor_path(@vendor)
  end

  def then_i_should_be_provided_with_vendor_id_and_name
    expect(subject).to include('id' => @vendor.id,
                               'name' => @vendor.name)
  end

  private

  let(:vendor_attrs) do
    { 'name' => 'Surfin USA' }
  end
end
