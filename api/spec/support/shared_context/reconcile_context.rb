RSpec.shared_context 'reconcile context' do
  let!(:purchase_order) do
    create_list(:purchase_order_line_item,
                1,
                :with_summary,
                :balance,
                season: Season.all[5].SeasonNickname,
                sku: sku,
                delivery_date: Time.new(2013, 1, 1))
  end

  let!(:sku) do
    create(:base_sku,
           :with_barcode,
           :with_product,
           sku: '3-1666',
           season: Season.all[5])
  end

  let!(:sku2) do
    create(:base_sku,
           :with_barcode,
           :with_product,
           sku: '3-4444',
           season: Season.all[3])
  end


  let!(:pvx_in) do
    create(:pvx_in,
           sku: sku.sku,
           qty: 1,
           po_number: purchase_order.first.po_number,
           delivery_note: '123456789',
           po_status: 0,
           product_id: sku.product_id)
  end

  let(:invalid_pvx_in_po) do
    GoodsIn::Normalizer::INVLAID_PVX_IN_PO_LINE
  end

  let(:with_balance) do
    PurchaseOrder::Reconciler::PURCHASE_ORDER_LINE_WITH_BALANCE
  end

  let(:completed_po) do
    PurchaseOrder::Reconciler::COMPLETED_PURCHASE_ORDER_LINE
  end

  let(:completed_pvx_in_po) do
    PurchaseOrder::Reconciler::COMPLETED_PVX_IN_PO
  end

  let(:ready_to_recocile) do
    GoodsIn::Normalizer::READY_TO_RECOCILE
  end
end
