feature 'Listing Elements' do
  subject { JSON.parse(page.body) }

  scenario 'Listing elements' do
    when_i_request_a_list_of_elements
    then_i_have_a_list_of_elements
  end

  def when_i_request_a_list_of_elements
    create_elements
    visit elements_path
  end

  def then_i_have_a_list_of_elements
    expect(subject['elements'].count).to be(5)
    expect(subject['elements'][0]).to match(a_hash_including('id', 'name'))
  end

  let(:create_elements) { create_list(:element, 5) }
end
