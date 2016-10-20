require 'spec_helper'

describe OverDelivery::Generator do
  let!(:purchase_order) do
    create(:purchase_order_line_item,
           :with_summary,
           sku_id: sku.id,
           po_number: 1001
          )
  end
  let(:sku) do
    create(:base_sku,
           :with_barcode,
           :with_product,
           season: Season.all[5]
          )
  end
  let(:attrs) do
    {
      sku: sku.sku,
      quantity: 4,
      user_id: 1,
      grn: '10001',
      po_numbers: [
        purchase_order.po_number
      ]
    }
  end

  subject { described_class.new(attrs) }

  context "Generates required objects for an over po" do
    [OverDelivery, Order, OrderLineItem, PurchaseOrderLineItem].each do |object|
      it "creates #{object}" do
        expect { subject.generate }.to change(object, :count).by(1)
      end
    end
  end

  context "Correct attributes" do
    before { subject.generate }

    it "OverDelivery" do
      over_delivery = OverDelivery.last
      attrs.except(:po_numbers).keys.each do |attribute|
        expect(over_delivery.send(attribute)).to eq attrs[attribute]
      end
    end

    it "Order" do
      order, over_delivery = Order.last, OverDelivery.last
      expect(order.name).to eq "OVER_#{over_delivery.id}"
      expect(order.order_type).to eq 'over_po'
      expect(order.season).to eq sku.season.nickname
    end

    it "OrderLineItem" do
      line_item, order = OrderLineItem.last, Order.last
      expect(line_item.internal_sku).to eq attrs[:sku]
      expect(line_item.quantity).to eq attrs[:quantity]
      expect(line_item.cost).to eq purchase_order.cost
      expect(line_item.order_id).to eq order.id
      expect(line_item.vendor_id).to eq sku.vendor_id
      expect(line_item.season).to eq sku.season.nickname
      expect(line_item.sku_id).to eq sku.id
      expect(line_item.product_id).to eq sku.product_id
    end

    it "Purchase_order" do
      po_line_item, line_item = PurchaseOrderLineItem.last, OrderLineItem.last
      expect(po_line_item.quantity).to eq attrs[:quantity]
      expect(po_line_item.quantity_done).to eq attrs[:quantity]
      expect(po_line_item.attributes.fetch('status')).to eq 5
      expect(po_line_item.operator).to eq 'O_U_TOOL'
      expect(po_line_item.cost).to eq line_item.cost
      expect(po_line_item.po_season).to eq sku.season.nickname
      expect(po_line_item.sku_id).to eq sku.id
    end
  end
end
