RSpec.shared_context 'po batch file context' do
  let(:sku) do
    create(:base_sku,
           :with_barcode,
           :with_product,
           season: Season.all[5])
  end

  let(:purchase_order_line_item) do
    create(:purchase_order_line_item,
           :with_summary,
           sku_id: sku.id,
           supplier_cost_price: 100,
           po_season: Season.all[5].SeasonNickname,
           status: 2,
           po_number: 1001)
  end

  let(:purchase_order) do
    create(:purchase_order, po_num: purchase_order_line_item.po_number)
  end
end
