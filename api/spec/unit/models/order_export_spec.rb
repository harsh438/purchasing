RSpec.describe OrderExport, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:order) }
    it { should belong_to(:purchase_order) }
  end
end
