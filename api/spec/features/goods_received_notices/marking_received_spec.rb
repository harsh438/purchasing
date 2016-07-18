feature 'Marking Purchase Order as received', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Marking PO as received' do
    when_a_purchase_order_is_received
    then_grn_should_report_received_units
  end

  def when_a_purchase_order_is_received
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_attrs }
  end

  def then_grn_should_report_received_units
    expect(subject['status']).to eq('received')
    expect(subject['received']).to eq(1)
    expect(subject['received_at']).to be_present
    expect(subject['goods_received_notice_events'].first['status']).to eq('received')
    expect(subject['units_received']).to eq(grn.goods_received_notice_events.first.units)
    expect(subject['cartons_received']).to eq(grn.goods_received_notice_events.first.cartons)
  end

  private

  let(:grn) { create(:goods_received_notice, :with_purchase_orders) }

  let(:grn_event) { grn.goods_received_notice_events.first }

  let(:grn_attrs) do
    { goods_received_notice_events_attributes: [{ id: grn_event.id,
                                                  received: true }] }
  end
end
