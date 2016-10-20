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

  context "Class method" do
  subject { described_class }
  let(:purchase_order) { create(:purchase_order_line_item, po_number: 1001) }
  let(:season) { create(:season, nickname: purchase_order.po_season) }

    it "returns latest season from a list of POs" do
      expect(subject.season([purchase_order.po_number])).to eq 'AW15'
    end
  end
end
