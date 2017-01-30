RSpec.describe GoodsIn::Normalizer do
  include_context 'reconcile context'
  context "Normalizer" do
    let(:attrs) do
      create(:pvx_in,
             sku: sku.sku,
             po_number: nil,
             delivery_note: '123456789',
             po_status: 0,
             product_id: sku.product_id)
    end

    context "no purchase order" do
      it "pvx_in line without a purchase order number " do
        described_class.new(attrs).process
        normalize_line = PvxInPo.last
        expect(normalize_line.status).to eq invalid_pvx_in_po
        expect(normalize_line.purchase_order_line_id).to eq nil
      end
    end

    context 'with a purchase order' do
      it "with a balance" do
        described_class.new(pvx_in).process
        normalize_line = PvxInPo.last
        expect(normalize_line.status).to eq ready_to_recocile
        expect(normalize_line.purchase_order_line_id).to eq purchase_order.first.id
      end

      it "without a balance" do
        PvxIn.last.update_attribute(:qty, 33_333)
        described_class.new(PvxIn.last).process
        normalize_line = PvxInPo.last
        expect(normalize_line.status).to eq invalid_pvx_in_po
        expect(normalize_line.purchase_order_line_id).to eq nil
      end

      it 'can not find sku' do
        PvxIn.last.update_attribute(:sku, '888-88')
        described_class.new(PvxIn.last).process
        normalize_line = PvxInPo.last
        expect(normalize_line.status).to eq invalid_pvx_in_po
        expect(normalize_line.purchase_order_line_id).to eq nil
      end

      it 'missing purchase order line for a sku' do
        PvxIn.last.update_attribute(:sku, sku2.sku)
        described_class.new(PvxIn.last).process
        normalize_line = PvxInPo.last
        expect(normalize_line.status).to eq invalid_pvx_in_po
        expect(normalize_line.purchase_order_line_id).to eq nil
      end
    end
  end
end
