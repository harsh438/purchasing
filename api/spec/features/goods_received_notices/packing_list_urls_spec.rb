feature 'Packing List URLS' do
  subject { JSON.parse(page.body) }

  scenario 'Fetch a GRN with packing list' do
    when_i_request_an_existing_grn_with_packing_list
    then_i_should_have_packing_urls
  end

  scenario 'Fetch a GRN with packing list with strange filename' do
    when_i_request_an_existing_grn_with_packing_list_with_a_strange_filename
    then_i_should_have_one_packing_url_properly_encoded
  end

  def when_i_request_an_existing_grn_with_packing_list
    visit goods_received_notice_path(grn_with_packing_list)
  end

  def then_i_should_have_packing_urls
    expect(subject['packing_list_urls'].count).not_to eq(0)
  end

  def when_i_request_an_existing_grn_with_packing_list_with_a_strange_filename
    visit goods_received_notice_path(grn_with_packing_list_with_invalid_characters)
  end

  def then_i_should_have_one_packing_url_properly_encoded
    grn = grn_with_packing_list_with_invalid_characters
    expect(subject['packing_list_urls'].count).to eq(1)
    expect(subject['packing_list_urls'][0]).to include(URI.escape(grn.Attachments[1..-1]))
    expect(subject['packing_list_urls'][0][0]).not_to be(',')
  end

  let(:grn_with_packing_list) { create(:goods_received_notice, :with_purchase_list) }
  let(:grn_with_packing_list_with_invalid_characters) do
    create(:goods_received_notice, :with_packing_list_with_invalid_characters)
  end
end
