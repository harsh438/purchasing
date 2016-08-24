RSpec.describe Vendor, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should have_many(:supplier_vendors).with_foreign_key(:BrandID) }
    it { should have_many(:suppliers).through(:supplier_vendors) }
    it { should have_many(:products).with_foreign_key(:venID) }

    it { should have_one(:details) }

    it { should accept_nested_attributes_for(:details) }
  end
end
