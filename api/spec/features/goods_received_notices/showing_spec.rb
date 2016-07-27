feature 'Showing GRN', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Fetching a single GRN' do
    when_i_request_a_grn_which_exists
    then_i_should_see_the_grns_attributes
  end

  scenario 'Fetching a GRN with an issue' do
    when_i_request_a_grn_with_an_issue
    then_i_should_see_the_issues_on_the_grn
  end

  def when_i_request_a_grn_which_exists
    visit goods_received_notice_path(grn.id)
  end

  def then_i_should_see_the_grns_attributes
    expect(subject).to include('units_received', 'cartons_received', 'delivery_date', 'id')
  end

  def when_i_request_a_grn_with_an_issue
    visit goods_received_notice_path(grn_with_issue.id)
  end

  def then_i_should_see_the_issues_on_the_grn
    expect(subject['issues'].first['issue_type']).to eq('cartons_good_condition')
    expect(subject['issues'].first['issue_type_id']).to eq(3)
  end

  let(:grn) { create(:goods_received_notice) }
  let(:grn_with_issue) { create(:goods_received_notice, :with_issue) }
end
