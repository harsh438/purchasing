RSpec.describe PvxIn, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:product).with_foreign_key(:pid) }
  end
end
