RSpec.describe GoodsReceivedNoticeIssue do
  context 'when creating a simple issue' do
    subject { issues.create(issue_type: :cartons_good_condition, units_affected: 5) }

    it 'sets the correct Issue Type ID from its Issue Type name' do
      expect(subject.issue_type_id).to eq(3)
    end
  end

  let(:grn) { create(:goods_received_notice) }
  let(:issues) { grn.goods_received_notice_issues }
end
