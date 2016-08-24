RSpec.describe Order, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should have_many(:line_items) }
    it { should have_many(:exports) }
    it { should have_many(:purchase_orders).through(:exports) }
    it { should accept_nested_attributes_for(:line_items) }
  end
end
