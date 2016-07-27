RSpec.describe GoodsReceivedNoticeIssue do
  context 'when creating a simple issue' do
    it 'sets the correct Issue Type ID from its Issue Type name' do
      expect(simple_issue.issue_type_id).to eq(3)
    end

    it 'stores references to its attachments on itself' do
      expect(simple_issue.goods_received_notice_issue_images.count).to eq(1)
      expect(simple_issue.attachments).to eq(',1x1.jpg')
    end
  end

  context 'when adding an image to an existing issue' do
    before(:each) do
      create(:goods_received_notice_issue_image, goods_received_notice_issue: simple_issue)
    end

    it 'updates its attachment references' do
      expect(simple_issue.attachments).to eq(',1x1.jpg,1x1.jpg')
    end
  end

  context 'when removing an image from an existing issue' do
    before(:each) do
      simple_issue.goods_received_notice_issue_images.last.destroy
    end

    it 'updates its attachment references' do
      expect(simple_issue.reload.attachments).to eq(nil)
    end
  end

  let(:simple_issue) { create(:goods_received_notice_issue, :with_images,
                              issue_type: :cartons_good_condition,
                              units_affected: 5) }
end
