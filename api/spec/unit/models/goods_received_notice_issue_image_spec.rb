RSpec.describe GoodsReceivedNoticeIssueImage, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:goods_received_notice_issue) }
  end
end
