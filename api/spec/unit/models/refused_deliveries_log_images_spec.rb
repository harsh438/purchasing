RSpec.describe RefusedDeliveriesLogImage, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:refused_deliveries_log) }
    it { should have_attached_file(:image) }
  end
end
