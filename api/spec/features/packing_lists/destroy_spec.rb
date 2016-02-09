feature 'Destroy Packing Lists' do
  subject { JSON.parse(page.body) }

  scenario 'Destroying an old packing List' do
    when_i_destroy_an_old_packing_list_from_an_existing_grn
    it_should_be_removed_from_the_list_of_urls
  end

  def when_i_destroy_an_old_packing_list_from_an_existing_grn
    path = delete_packing_list_goods_received_notice_path(grn_with_packing_list)
    page.driver.post path, { _method: 'delete', packing_list: { url: grn_with_packing_list.packing_list_urls[1] } }
  end

  def it_should_be_removed_from_the_list_of_urls
    old_url_count = grn_with_packing_list.packing_list_urls.count
    expect(subject['packing_list_urls'].count).to eq(old_url_count - 1) # one is now removed
  end

  let(:grn_with_packing_list) { create(:goods_received_notice, :with_multiple_packing_lists) }
end
