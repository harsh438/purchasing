RSpec.describe ProductCategory, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:product).with_foreign_key(:pID) }
    it { should belong_to(:category).with_foreign_key(:catID) }
  end
end
