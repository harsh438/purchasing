RSpec.describe ReportingCategory, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:product).with_foreign_key(:pid) }
    it { should belong_to(:category).with_foreign_key(:catid) }
  end
end
