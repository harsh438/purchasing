feature 'Associating buyers to Supplier' do
  subject { JSON.parse(page.body) }

  scenario 'Adding a buyer' do
    when_i_add_a_buyer_to_a_supplier
    then_the_buyer_should_be_listed_under_supplier
  end

  scenario 'Editing a buyer' do
    when_i_update_a_buyer_of_a_supplier
    then_the_updated_buyer_should_be_listed_under_supplier
  end

  def when_i_add_a_buyer_to_a_supplier
    page.driver.post(supplier_path(create(:supplier)),
                     _method: 'patch',
                     supplier: { buyers_attributes: [buyer_attrs] })
  end

  def then_the_buyer_should_be_listed_under_supplier
    expect(subject).to include('buyers' => array_including(a_hash_including(buyer_attrs)))
  end

  def when_i_update_a_buyer_of_a_supplier
    supplier = create(:supplier, buyers: [supplier_buyer])

    page.driver.post(supplier_path(supplier),
                     _method: 'patch',
                     supplier: { buyers_attributes: [updated_attrs] })

  end

  def then_the_updated_buyer_should_be_listed_under_supplier
    expect(subject).to include('buyers' => array_including(a_hash_including(updated_attrs)))
  end

  private

  let(:buyer_attrs) do
    attributes_for(:supplier_buyer).stringify_keys
  end

  let(:supplier_buyer) do
    create(:supplier_buyer)
  end

  let(:updated_attrs) do
    { 'id' => supplier_buyer.id, 'buyer_name' => 'Bob' }
  end
end
