RSpec.describe PackingList, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:goods_received_notice) }
    it { should have_attached_file(:list) }
  end
end
