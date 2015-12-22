feature 'Suppliers Terms' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of SuppliersTerms pagination' do
    when_i_request_list_of_supplier_terms
    then_i_should_see_paginated_list_of_supplier_terms
  end

  scenario 'Adding terms to Supplier' do
    when_i_add_a_set_of_terms_to_a_supplier
    then_those_terms_should_be_listed_under_the_supplier
  end

  scenario 'Updating terms to Supplier' do
    when_updating_supplier_terms
    then_new_terms_should_be_created
  end

  scenario 'Validating terms fields' do
    when_updating_supplier_terms_with_invalid_input_should_error
  end

  def when_i_request_list_of_supplier_terms
    create_list(:supplier_terms, 52, default: true)
    visit supplier_terms_path
  end

  def then_i_should_see_paginated_list_of_supplier_terms
    expect(subject['terms'].count).to eq(50)
    expect(subject['total_pages']).to eq(2)
    expect(subject['terms']).to include(a_hash_including('id', 'supplier_name', 'by', 'parent_id'))
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

  def when_updating_supplier_terms_with_invalid_input_should_error
    expect {
      page.driver.post(supplier_path(create(:supplier, terms: terms_attrs)),
                       _method: 'patch',
                       supplier: { terms: terms_attrs.merge(invalid_attrs) })
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  let(:terms_attrs) do
    attributes_for(:supplier_terms).stringify_keys
  end

  let(:updated_attrs) do
    { 'id' => create(:supplier_terms).id, 'pre_order_discount' => '30.0' }
  end

  let(:invalid_attrs) do
    { 'id' => create(:supplier_terms).id, 'credit_limit' => 'derek' }
  end
end
