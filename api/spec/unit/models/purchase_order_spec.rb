RSpec.describe PurchaseOrder, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should have_many(:line_items).with_foreign_key(:po_number) }
    it { should have_many(:order_exports) }
    it { should have_many(:orders).through(:order_exports) }
    it { should have_many(:goods_received_notice_events).with_foreign_key(:po) }

    it { should belong_to(:vendor).with_foreign_key(:venID) }
  end
end
