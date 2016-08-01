RSpec.describe  PurchaseOrderLineItem, type: :model do
  describe "Shoulda", type: :shoulda do
    it { should belong_to(:vendor).with_foreign_key(:orderTool_venID) }
    it { should belong_to(:product).with_foreign_key(:pID) }
    it { should belong_to(:option).with_foreign_key(:oID) }
    it { should belong_to(:purchase_order).with_foreign_key(:po_number) }
    it { should belong_to(:sku) }
    it { should belong_to(:language_category).with_foreign_key(:category_id) }

    it { should have_many(:suppliers).through(:vendor) }
  end
end
