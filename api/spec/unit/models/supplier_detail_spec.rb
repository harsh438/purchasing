RSpec.describe SupplierDetail, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:supplier) }
  end
end
