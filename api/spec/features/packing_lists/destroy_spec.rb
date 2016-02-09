feature 'Destroy Packing Lists' do
  subject { JSON.parse(page.body) }

  scenario 'Destroying an old packing List' do
    when_i_destroy_an_old_packing_list_from_an_existing_grn
    it_should_be_removed_from_the_list_of_urls(grn_with_packing_list)
  end

  scenario 'Destroying an current packing List' do
    when_i_destroy_an_current_packing_list_from_an_existing_grn
    it_should_be_removed_from_the_list_of_urls(grn_with_both_packing_lists)
  end

  def when_i_destroy_an_old_packing_list_from_an_existing_grn
    grn = grn_with_packing_list.as_json_with_purchase_orders_and_packing_list_urls
    path = delete_packing_list_goods_received_notice_path(grn_with_packing_list)
    page.driver.post path, {
        _method: 'delete',
        packing_list_attributes: { list_url: grn[:packing_list_urls][1] } }
  end

  def it_should_be_removed_from_the_list_of_urls(grn)
    old_url_count = grn.as_json_with_purchase_orders_and_packing_list_urls[:packing_list_urls].count
    expect(subject['packing_list_urls'].count).to eq(old_url_count - 1) # one is now removed
  end

  def when_i_destroy_an_current_packing_list_from_an_existing_grn
    packing_list = grn_with_both_packing_lists.packing_lists[0].list_url # picking a packing list to delete
    path = delete_packing_list_goods_received_notice_path(grn_with_both_packing_lists)
    page.driver.post path, {
        _method: 'delete',
        packing_list_attributes: { list_url: packing_list } }
  end

  let(:grn_with_packing_list) { create(:goods_received_notice, :with_multiple_packing_lists) }
  let(:grn_with_both_packing_lists) { create(:goods_received_notice, :with_both_packing_lists) }

end
