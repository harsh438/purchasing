feature 'Associating contacts to Supplier' do
  subject { JSON.parse(page.body) }

  scenario 'Adding a contact' do
    when_i_add_a_contact_to_a_supplier
    then_the_contact_should_be_listed_under_supplier
  end

  scenario 'Editing a contact' do
    when_i_update_a_contact_of_a_supplier
    then_the_updated_contact_should_be_listed_under_supplier
  end

  def when_i_add_a_contact_to_a_supplier
    page.driver.post(supplier_path(create(:supplier)),
                     _method: 'patch',
                     supplier: { contacts_attributes: [contact_attrs] })
  end

  def then_the_contact_should_be_listed_under_supplier
    expect(subject).to include('contacts' => array_including(a_hash_including(contact_attrs)))
  end

  def when_i_update_a_contact_of_a_supplier
    supplier = create(:supplier, contacts: [supplier_contact])

    page.driver.post(supplier_path(supplier),
                     _method: 'patch',
                     supplier: { contacts_attributes: [updated_attrs] })

  end

  def then_the_updated_contact_should_be_listed_under_supplier
    expect(subject).to include('contacts' => array_including(a_hash_including(updated_attrs)))
  end

  private

  let(:contact_attrs) do
    attributes_for(:supplier_contact).stringify_keys
  end

  let(:supplier_contact) do
    create(:supplier_contact)
  end

  let(:updated_attrs) do
    { 'id' => supplier_contact.id, 'name' => 'Bob' }
  end
end
