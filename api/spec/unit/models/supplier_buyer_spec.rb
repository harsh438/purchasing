RSpec.describe SupplierBuyer, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:supplier) }
  end
end
