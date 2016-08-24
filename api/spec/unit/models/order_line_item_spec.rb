RSpec.describe OrderLineItem, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:order) }
    it { should belong_to(:sku) }
    it { should belong_to(:product) }
    it { should validate_presence_of(:cost) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:drop_date) }

    it do
      should validate_numericality_of(:quantity)
        .only_integer
        .is_greater_than_or_equal_to(1)
    end

    it do
      should validate_numericality_of(:discount)
      .is_greater_than_or_equal_to(0)
      .is_less_than_or_equal_to(100)
    end
  end
end
