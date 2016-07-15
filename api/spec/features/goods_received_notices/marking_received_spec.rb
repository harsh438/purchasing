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
    expect(subject['units_received']).to eq(1)
    expect(subject['cartons_received']).to eq(1)
  end

  private

  let(:grn) { create(:goods_received_notice, :with_purchase_orders) }

  let(:grn_event) { grn.goods_received_notice_events.first }

  let(:grn_attrs) do
    { units_received: 1,
      cartons_received: 1,
      goods_received_notice_events_attributes: [{ id: grn_event.id,
                                                  received: true }] }
  end
end
