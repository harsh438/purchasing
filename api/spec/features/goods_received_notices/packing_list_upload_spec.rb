feature 'Packing List URL Upload' do
  subject { JSON.parse(page.body) }

  scenario 'Adding a packing list file to a GRN' do
    when_i_upload_a_packing_list_file
    then_the_packing_list_should_be_stored
  end

  scenario 'Adding a packing list file to a GRN with legacy attachments' do
    when_i_upload_a_packing_list_file_to_a_grn_with_legacy_attachments
    then_the_packing_list_urls_should_have_both_lists
  end

  def when_i_upload_a_packing_list_file
    page.driver.post(goods_received_notice_path(grn),
                     _method: 'patch',
                     goods_received_notice: { packing_lists_attributes: [{list: fixture_packing_file_upload}] })
  end

  def when_i_upload_a_packing_list_file_to_a_grn_with_legacy_attachments
    page.driver.post(goods_received_notice_path(grn_with_purchase_list),
                     _method: 'patch',
                     goods_received_notice: { packing_lists_attributes: [{list: fixture_packing_file_upload}] })
  end

  def then_the_packing_list_should_be_stored
    expect(grn.packing_lists.count).to be(1)
  end

  def then_the_packing_list_urls_should_have_both_lists
    expect(grn_with_purchase_list.packing_list_urls.count).to be(3) # 2 legacy + 1 new = 3
  end

  let(:fixture_packing_file_upload) do
    fixture_file_upload(Rails.root.join('spec/fixtures/files/1x1.jpg'), 'image/jpeg')
  end
  let(:grn) { create(:goods_received_notice) }
  let(:grn_with_purchase_list) { create(:goods_received_notice, :with_purchase_list) }

end
