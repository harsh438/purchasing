feature 'Deleting GRN', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Delete a GRN' do
    when_i_delete_a_grn
    then_it_should_no_longer_be_listed
  end

  def when_i_delete_a_grn
    page.driver.post goods_received_notice_path(grn), { _method: 'delete' }
  end

  def then_it_should_no_longer_be_listed
    expect(subject['success']).to eq(true)
  end

  private

  let(:grn) { create(:goods_received_notice) }
end
