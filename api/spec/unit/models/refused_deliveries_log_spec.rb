RSpec.describe RefusedDeliveriesLog, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:vendor).with_foreign_key(:brand_id) }
    it { should have_many(:refused_deliveries_log_images) }
    it { should accept_nested_attributes_for(:refused_deliveries_log_images) }
  end
end
