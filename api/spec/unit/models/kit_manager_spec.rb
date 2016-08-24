RSpec.describe KitManager, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:product).with_foreign_key(:pID) }
    it { should belong_to(:source_product).with_foreign_key(:sourcepID) }
    it { should belong_to(:source_option).with_foreign_key(:sourceoID) }
  end
end
