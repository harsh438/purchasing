RSpec.shared_context 'batchfile purchase order updates by product' do
  let!(:purchase_order) { create(:purchase_order, :with_line_items, po_num: 123) }
  let(:product) { Product.first }
  let(:po_line_item) { PurchaseOrderLineItem.first }

  before do
    PurchaseOrderLineItem.all.each do |po_line_item|
      po_line_item.update_attributes!(product: product)
    end
  end
end
