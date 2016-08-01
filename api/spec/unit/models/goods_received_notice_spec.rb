RSpec.describe GoodsReceivedNotice, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:order).with_foreign_key(:OrderID) }
    it { should belong_to(:user).with_foreign_key(:UserID) }
    it { should have_many(:goods_received_notice_events) }
    it { should accept_nested_attributes_for(:goods_received_notice_events) }
    it { should have_many(:vendors).through(:goods_received_notice_events) }
    it { should have_many(:purchase_orders).through(:goods_received_notice_events) }
    it { should have_many(:packing_lists) }
    it { should have_one(:packing_condition) }
    it { should accept_nested_attributes_for(:goods_received_notice_issues).
        allow_destroy(true) }
  end
end
