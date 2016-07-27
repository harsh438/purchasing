RSpec.describe GoodsReceivedNoticeIssue do
  context 'when creating a simple issue' do
    it 'sets the correct Issue Type ID from its Issue Type name' do
      expect(simple_issue.issue_type_id).to eq(3)
    end
  end

  let(:simple_issue) { create(:goods_received_notice_issue, issue_type: :cartons_good_condition,
                                                            units_affected: 5) }
end
