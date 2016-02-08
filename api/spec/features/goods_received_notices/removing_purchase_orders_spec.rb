feature 'Removing Purchase Order from Goods Received Notice', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Removing valid PO to GRN' do
    when_removing_purchase_order_from_grn
    then_purchase_order_should_not_be_listed_under_grn
  end

  scenario 'Removing PO to GRN should decrement unit, carton and pallet totals' do
    when_removing_purchase_order_from_grn_with_existing_purchase_orders
    then_only_totals_from_new_purchase_orders_should_be_added_from_grn
  end

  def when_removing_purchase_order_from_grn
    set_purchase_order_before_its_deleted
    path = goods_received_notice_path(grn_with_pos)
    page.driver.post path, { _method: 'patch',
                             goods_received_notice: grn_with_po_attrs }
  end

  def then_purchase_order_should_not_be_listed_under_grn
    expect(subject['goods_received_notice_events']).to_not include(a_hash_including('purchase_order_id' => purchase_order.id))
  end

  def when_removing_purchase_order_from_grn_with_existing_purchase_orders
    page.driver.post goods_received_notice_path(grn_with_pos), { _method: 'patch',
                                                                 goods_received_notice: grn_with_po_attrs }
  end

  def then_only_totals_from_new_purchase_orders_should_be_added_from_grn
    grn_event = subject['goods_received_notice_events']
    expect(subject['units']).to eq(grn_event.sum { |grn_event| grn_event['units'] })
    expect(subject['cartons']).to eq(grn_event.sum { |grn_event| grn_event['cartons'] })
    expect(subject['pallets']).to eq(grn_event.sum { |grn_event| grn_event['pallets'].to_f }.to_f.to_s)
  end

  private

  let(:grn_with_pos) { create(:goods_received_notice, :with_purchase_orders) }

  let(:purchase_order) { grn_with_pos.goods_received_notice_events.first.purchase_order }
  alias_method :set_purchase_order_before_its_deleted, :purchase_order

  let(:grn_with_po_attrs) do
    { goods_received_notice_events_attributes: [{ id: grn_with_pos.goods_received_notice_events.first.id,
                                                  _destroy: '1' }] }
  end
end
