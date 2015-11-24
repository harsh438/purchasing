feature 'Associating contacts to Supplier' do
  subject { JSON.parse(page.body) }

  scenario 'Adding a contact' do
    when_i_add_a_contact_to_a_supplier
    then_the_contact_should_be_listed_under_supplier
  end

  def when_i_add_a_contact_to_a_supplier
    page.driver.post(supplier_path(create(:supplier)),
                     _method: 'patch',
                     supplier: { contacts_attributes: [contact_attrs] })
  end

  def then_the_contact_should_be_listed_under_supplier
    expect(subject).to include('contacts' => array_including(a_hash_including(contact_attrs)))
  end

  private

  let(:contact_attrs) do
    attributes_for(:supplier_contact).stringify_keys
  end
end
