require 'spec_helper'

describe OverDelivery::Cost do

  let!(:sku_1) { create(:base_sku, :with_product) }
  let!(:sku_2) { create(:base_sku, :with_product, cost_price: 0) }
  let(:sku_object_1) { Sku.where(id: sku_1.id) }
  let(:sku_object_2) { Sku.where(id: sku_2.id) }
  let(:po_line_item_1) { create(:purchase_order_line_item, orderTool_SupplierListPrice: 100, cost: 0) }
  let(:po_line_item_2) { create(:purchase_order_line_item, orderTool_SupplierListPrice: 0, cost: 200) }
  let(:po_line_item_3) { create(:purchase_order_line_item, orderTool_SupplierListPrice: 0, cost: 0) }

  subject { described_class }

  context "returns correct cost from different sources" do
    it "po orderTool_SupplierListPrice" do
      expect(subject.new(po_line_item_1, sku_object_1).process).to eq po_line_item_1.orderTool_SupplierListPrice
    end

    it "po cost" do
      expect(subject.new(po_line_item_2, sku_object_1).process).to eq po_line_item_2.cost
    end

    it "sku cost_price" do
      expect(subject.new(po_line_item_3, sku_object_1).process).to eq sku_1.cost_price
    end
    it "pCost" do
      expect(subject.new(po_line_item_3, sku_object_2).process).to eq sku_2.product.pCost
    end
  end
end
