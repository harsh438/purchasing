feature 'Adding Purchase Order to Goods Received Notice', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Adding valid PO to GRN' do
    when_adding_purchase_order_to_grn
    then_purchase_order_should_be_listed_under_grn
  end

  scenario 'Adding PO to GRN should increment unit, carton and pallet totals' do
    when_adding_purchase_order_to_grn_with_existing_purchase_orders
    then_only_totals_from_new_purchase_orders_should_be_added_to_grn
  end

  def when_adding_purchase_order_to_grn
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_with_po_attrs }
  end

  def then_purchase_order_should_be_listed_under_grn
    expect(subject['goods_received_notice_events']).to include(a_hash_including('purchase_order_id' => purchase_order.id))
  end

  def when_adding_purchase_order_to_grn_with_existing_purchase_orders
    page.driver.post goods_received_notice_path(grn_with_pos), { _method: 'patch',
                                                                 goods_received_notice: grn_with_po_attrs }
  end

  def then_only_totals_from_new_purchase_orders_should_be_added_to_grn
    expect(subject['units']).to eq(subject['goods_received_notice_events'].sum { |grn_event| grn_event['units'] })
    expect(subject['cartons']).to eq(subject['goods_received_notice_events'].sum { |grn_event| grn_event['cartons'] })
    expect(subject['pallets']).to eq(subject['goods_received_notice_events'].sum { |grn_event| grn_event['pallets'].to_f }.to_s)
  end

  private

  let(:grn) { create(:goods_received_notice) }
  let(:grn_with_pos) { create(:goods_received_notice, :with_purchase_orders) }

  let(:purchase_order) { create(:purchase_order) }

  let(:grn_with_po_attrs) do
    { goods_received_notice_events_attributes: [{ purchase_order_id: purchase_order.id,
                                                  units: 10,
                                                  cartons: 4,
                                                  pallets: 2 }] }
  end
end
