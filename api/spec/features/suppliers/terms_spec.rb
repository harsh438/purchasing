feature 'Suppliers Terms' do
  subject { JSON.parse(page.body) }

  scenario 'Listing of SuppliersTerms pagination' do
    when_i_request_list_of_supplier_terms
    then_i_should_see_paginated_list_of_supplier_terms
  end

  scenario 'Adding terms to Supplier without Brand' do
    when_i_add_a_set_of_terms_to_a_supplier_without_brand
    then_those_terms_should_be_listed_under_the_supplier_without_brand
  end

  scenario 'Adding terms to Supplier with Brand' do
    when_i_add_a_set_of_terms_to_a_supplier_with_brand
    then_those_terms_should_be_listed_under_the_supplier_with_brand
  end

  scenario 'Updating terms to Supplier without Brand' do
    when_updating_supplier_terms_without_brand
    then_new_terms_should_not_be_created_without_brand
  end

  scenario 'Adding terms for brand to supplier with brandless terms' do
    when_adding_terms_for_brand_to_supplier_with_brandless_terms
    then_supplier_should_have_multiple_default_terms
  end

  scenario 'Adding terms for brand to supplier with multiple terms' do
    when_adding_terms_for_brand_to_supplier_with_multiple_terms
    then_supplier_should_have_multiple_default_terms_by_brands
  end

  scenario 'Adding confirmation file to terms' do
    when_adding_a_confirmation_file_to_terms
    then_new_terms_should_be_created
  end

  scenario 'Validating terms fields' do
    when_updating_supplier_terms_with_invalid_input_should_error
  end

  def when_adding_terms_for_brand_to_supplier_with_brandless_terms
    add_a_set_of_terms_to_a_supplier_with_brand(supplier_with_default_terms)
  end

  def when_adding_terms_for_brand_to_supplier_with_multiple_terms
    vendor_id = vendor_attrs['id']
    # creating three different terms with the same vendor_id for each
    create_terms_attrs_with_confirmation_file_and_vendor_id(vendor_id: vendor_id, count: 3).each do |term|
        add_a_set_of_terms_to_a_supplier(supplier_with_default_terms, term)
    end
  end

  def then_supplier_should_have_multiple_default_terms_by_brands
    expect(subject['terms_by_vendor'].count).to eq(2)
    expect(subject['terms_by_vendor'].first['history'].count).to eq(1)
    expect(subject['terms_by_vendor'].second['history'].count).to eq(3)
    expect(subject['terms_by_vendor'].second['history'].map do |history|
      history['default']
    end).to eq([false, false, true])
    expect(subject['terms_by_vendor'].first['default']['default']).to eq(true)
  end

  def then_supplier_should_have_multiple_default_terms
    expect(subject['terms_by_vendor'].count).to eq(2)
    expect(subject['terms_by_vendor'].first['default']['vendor_id']).to be_nil
    expect(subject['terms_by_vendor'].second['default']['vendor_id']).to eq(terms_attrs_with_brand['vendor_id'])
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

  def when_i_add_a_set_of_terms_to_a_supplier_without_brand
    page.driver.post(supplier_path(create(:supplier)),
                     _method: 'patch',
                     supplier: { terms: terms_attrs })
  end

  def then_those_terms_should_be_listed_under_the_supplier_without_brand
    expect(subject['terms']).to include(a_hash_including(terms_attrs))
  end

  def when_i_add_a_set_of_terms_to_a_supplier_with_brand
    add_a_set_of_terms_to_a_supplier_with_brand
  end

  def then_those_terms_should_be_listed_under_the_supplier_with_brand
    vendor_check = a_hash_including('id' => terms_attrs_with_brand['vendor_id'])
    expect(subject['terms']).to include(a_hash_including('vendor' => vendor_check))
  end

  def when_updating_supplier_terms_without_brand
    page.driver.post(supplier_path(create(:supplier, terms: terms_attrs)),
                     _method: 'patch',
                     supplier: { terms: terms_attrs.merge(updated_attrs) })
  end

  def when_adding_a_confirmation_file_to_terms
    page.driver.post(supplier_path(create(:supplier, terms: terms_attrs)),
                     _method: 'patch',
                     supplier: { terms: terms_attrs.merge(new_file_attrs) })
  end

  def then_new_terms_should_be_created
    next_id = new_file_attrs['id'] + 1
    expect(subject['terms']).to include(a_hash_including(terms_attrs.merge('id' => next_id)))
  end

  def then_new_terms_should_not_be_created_without_brand
    current_id = updated_attrs['id']
    expect(subject['terms']).to include(a_hash_including(updated_attrs.merge('id' => current_id)))
  end

  def when_updating_supplier_terms_with_invalid_input_should_error
    expect {
      page.driver.post(supplier_path(create(:supplier, terms: terms_attrs)),
                       _method: 'patch',
                       supplier: { terms: terms_attrs.merge(invalid_attrs) })
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  private

  let(:vendor_attrs) do
    create(:vendor).as_json
  end

  let(:terms_attrs) do
    attributes_for(:supplier_terms).stringify_keys
  end

  let(:terms_attrs_with_brand) do
    terms_attrs.merge('vendor_id' => create(:vendor).id)
  end

  let(:updated_attrs) do
    { 'id' => SupplierTerms.last.id, 'pre_order_discount' => '30.0' }
  end

  let(:new_file_attrs) do
    { 'id' => SupplierTerms.last.id,
      'confirmation' => fixture_confirmation_file_upload }
  end

  let(:invalid_attrs) do
    { 'id' => create(:supplier_terms).id, 'credit_limit' => 'derek' }
  end

  let(:supplier_with_default_terms) do
    create(:supplier, :with_default_terms)
  end


  def fixture_confirmation_file_upload
    fixture_file_upload(Rails.root.join('spec/fixtures/files/1x1.jpg'), 'image/jpeg')
  end

  def add_a_set_of_terms_to_a_supplier_with_brand(supplier = create(:supplier))
    page.driver.post(supplier_path(supplier),
                     _method: 'patch',
                     supplier: { terms: terms_attrs_with_brand })
  end

  def add_a_set_of_terms_to_a_supplier(supplier, terms)
    page.driver.post(supplier_path(supplier),
                     _method: 'patch',
                     supplier: { terms: terms })
  end

  def create_terms_attrs_with_confirmation_file_and_vendor_id(attrs = {})
    terms = []
    (1..attrs[:count]).each do
      terms << create_term_attrs_with_confirmation_file.merge('vendor_id' => attrs[:vendor_id])
    end
    terms
  end

  def create_term_attrs_with_confirmation_file_and_vendor_id(vendor_id)
    create_term_attrs_with_confirmation_file.merge('vendor_id' => vendor_id)
  end

  def create_term_attrs_with_confirmation_file
    attributes_for(:supplier_terms).stringify_keys.merge('confirmation' => fixture_confirmation_file_upload)
  end

end
