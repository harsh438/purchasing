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

  scenario 'Updating a vendor' do
    when_i_update_a_vendor
    then_the_vendor_should_be_updated
  end

  def when_i_create_a_vendor
    page.driver.post vendors_path(vendor: vendor_attrs)
  end

  def when_i_update_a_vendor
    page.driver.post(vendor_path(create(:vendor), format: :json),
                     vendor: update_vendor_attrs,
                     _method: 'patch')
  end

  def then_the_vendor_should_be_updated
    expect(subject).to include('name' => update_vendor_attrs['name'])
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
    attributes_for(:vendor, :with_details).stringify_keys
  end

  let(:update_vendor_attrs) do
    vendor_attrs.merge('name' => 'New Name!')
  end
end
