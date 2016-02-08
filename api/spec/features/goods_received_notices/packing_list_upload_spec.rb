feature 'Packing List URL Upload', booking_db: true do
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
                     goods_received_notice: { packing_lists_attributes: [{ list: fixture_packing_file_upload }] })
  end

  def then_the_packing_list_should_be_stored
    expect(subject['packing_list_urls'].count).to eq(1)
  end

  def when_i_upload_a_packing_list_file_to_a_grn_with_legacy_attachments
    page.driver.post(goods_received_notice_path(grn_with_packing_list),
                     _method: 'patch',
                     goods_received_notice: { packing_lists_attributes: [{ list: fixture_packing_file_upload }] })
  end

  def then_the_packing_list_urls_should_have_both_lists
    legacy_count = 1
    new_count = 1
    expect(subject['packing_list_urls'].count).to eq(legacy_count + new_count)
  end

  let(:fixture_packing_file_upload) do
    fixture_file_upload(Rails.root.join('spec/fixtures/files/1x1.jpg'), 'image/jpeg')
  end
  let(:grn) { create(:goods_received_notice) }
  let(:grn_with_packing_list) { create(:goods_received_notice, :with_packing_list) }
end
