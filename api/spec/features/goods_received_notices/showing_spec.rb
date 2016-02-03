feature 'Showing GRN' do
  scenario 'Fetching a single GRN' do
    when_i_request_a_grn_which_exists
    then_i_should_have_a_grn_as_json
  end

  def when_i_request_a_grn_which_exists
    grn = create(:goods_received_notice)
    visit goods_received_notice_path(grn.id)
  end

  def then_i_should_have_a_grn_as_json
    grn = JSON.parse page.body
    expect(grn).to include('units_received', 'cartons_received', 'delivery_date', 'id')
  end
end
