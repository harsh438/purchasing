RSpec.describe SupplierVendor, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:supplier).with_foreign_key(:SupplierID) }
    it { should belong_to(:vendor).with_foreign_key(:BrandID) }
  end
end
