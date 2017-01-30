RSpec.describe PurchaseOrder::Reconciler do
  include_context 'reconcile context'
  context "Reconciler" do
    let(:attrs) do
      create(:pvx_in_po,
             sku: sku.sku,
             purchase_order_number: purchase_order.first[:po_number],
             qty: 5,
             logged: "2017-01-16 10:05:13",
             status: 0,
             delivery_note: "123456789",
             pvx_in_ref: 1,
             purchase_order_line_id: purchase_order.first[:id])
    end

    let(:subject) { described_class.new(attrs) }

    it "Fully reconcile a purchase order line" do
      subject.reconcile
      expect(PvxInPo.last.status).to eq 1
      expect(PurchaseOrderLineItem.last[:status]).to eq 5
    end

    it "purchase order line with balance after reconciliation" do
      attrs.update_attribute(:qty, 80)
      subject.reconcile
      expect(PvxInPo.last.status).to eq invalid_pvx_in_po
      expect(PurchaseOrderLineItem.last[:status]).to eq 4
    end

    it "purchase order line with balance after reconciliation" do
      attrs.update_attribute(:qty, 1)
      subject.reconcile
      expect(PvxInPo.last.status).to eq 1
      expect(PurchaseOrderLineItem.last[:status]).to eq 4
    end
  end
  context "Reconciler mising data" do

    context "Mising Po line" do
      let(:attrs) do
        create(:pvx_in_po,
               sku: sku.sku,
               purchase_order_number: 1,
               qty: 5,
               logged: "2017-01-16 10:05:13",
               status: 0,
               delivery_note: "123456789",
               pvx_in_ref: 1,
               purchase_order_line_id: 199_999)
      end

      let(:subject) { described_class.new(attrs) }
      it "mising po line" do
        subject.reconcile
        expect(PvxInPo.last.status).to eq invalid_pvx_in_po
        expect(PvxInPo.last.purchase_order_number).to eq nil
        expect(PvxInPo.last.purchase_order_line_id).to eq nil
      end
    end
  end
end
