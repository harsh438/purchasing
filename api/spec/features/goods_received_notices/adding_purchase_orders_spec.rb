feature 'Adding Purchase Order to Goods Received Notice' do
  subject { JSON.parse(page.body) }

  scenario 'Adding valid PO to GRN' do
    when_adding_purchase_order_to_grn
    then_purchase_order_should_be_listed_under_grn
  end

  def when_adding_purchase_order_to_grn
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_with_po_attrs }
  end

  def then_purchase_order_should_be_listed_under_grn
    expect(subject['goods_received_notice_events']).to include(a_hash_including('purchase_order_id' => purchase_order.id))
  end

  private

  let(:grn) { create(:goods_received_notice) }

  let(:purchase_order) { create(:purchase_order) }

  let(:grn_with_po_attrs) do
    { goods_received_notice_events_attributes: [{ purchase_order_id: purchase_order.id,
                                                  units: 10,
                                                  cartons: 4,
                                                  pallets: 2 }] }
  end
end
