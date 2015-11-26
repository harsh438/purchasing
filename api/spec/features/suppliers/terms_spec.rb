feature 'Suppliers Terms' do
  subject { JSON.parse(page.body) }

  scenario 'Adding terms to Supplier' do
    when_i_add_a_set_of_terms_to_a_supplier
    then_those_terms_should_be_listed_under_the_supplier
  end

  scenario 'Updating terms to Supplier' do
    when_updating_supplier_terms
    then_new_terms_should_be_created
  end

  def when_i_add_a_set_of_terms_to_a_supplier
    page.driver.post(supplier_path(create(:supplier)),
                     _method: 'patch',
                     supplier: { terms: terms_attrs })
  end

  def then_those_terms_should_be_listed_under_the_supplier
    expect(subject['terms']).to include(a_hash_including(terms_attrs))
  end

  def when_updating_supplier_terms
    page.driver.post(supplier_path(create(:supplier, terms: terms_attrs)),
                     _method: 'patch',
                     supplier: { terms: terms_attrs.merge(updated_attrs) })
  end

  def then_new_terms_should_be_created
    next_id = updated_attrs['id'] + 1
    expect(subject['terms']).to include(a_hash_including(updated_attrs.merge('id' => next_id)),
                                        a_hash_including(terms_attrs))
  end

  let(:terms_attrs) do
    attributes_for(:supplier_terms).stringify_keys
  end

  let(:updated_attrs) do
    { 'id' => create(:supplier_terms).id, 'pre_order_discount' => '30.0' }
  end
end
