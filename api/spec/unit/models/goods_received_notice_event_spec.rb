RSpec.describe GoodsReceivedNoticeEvent, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:goods_received_notice).with_foreign_key(:grn) }
    it { should belong_to(:vendor).with_foreign_key(:BrandID) }
    it { should belong_to(:purchase_order).with_foreign_key(:po) }
    it { should belong_to(:user).with_foreign_key(:UserID) }
  end
end
