feature 'Suppliers Terms' do
  subject { JSON.parse(page.body) }

  scenario 'Adding terms to Supplier' do
    when_i_add_a_set_of_terms_to_a_supplier
    then_those_terms_should_be_listed_under_the_supplier
  end

  def when_i_add_a_set_of_terms_to_a_supplier
    page.driver.post(supplier_path(create(:supplier)),
                     _method: 'patch',
                     supplier: { terms: terms_attrs })
  end

  def then_those_terms_should_be_listed_under_the_supplier
    expect(subject['terms']).to include(a_hash_including(terms_attrs))
  end

  let(:terms_attrs) do
    attributes_for(:supplier_terms).stringify_keys
  end
end
