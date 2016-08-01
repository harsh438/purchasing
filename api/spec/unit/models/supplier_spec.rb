RSpec.describe Supplier, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should have_many(:supplier_vendors).with_foreign_key(:SupplierID) }
    it { should have_many(:vendors).through(:supplier_vendors) }
    it { should have_many(:contacts) }
    it { should have_many(:buyers) }
    it { should have_many(:terms) }

    it { should have_one(:details) }

    it { should accept_nested_attributes_for(:details) }
    it { should accept_nested_attributes_for(:contacts) }
    it { should accept_nested_attributes_for(:buyers) }
  end
end
