RSpec.describe Category, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should have_many(:language_categories).with_foreign_key(:catID) }
    it { should have_many(:product_categories).with_foreign_key(:catID) }
    it { should have_many(:reporting_categories).with_foreign_key(:catid) }
  end
end
