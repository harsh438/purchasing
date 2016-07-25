feature 'Marking Purchase Order as booked', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Marking a delivered PO as booked' do
    when_a_delivered_purchase_order_is_marked_as_booked
    then_grn_should_not_report_its_units
  end

  def when_a_delivered_purchase_order_is_marked_as_booked
    grn_event.update!(delivered: true)
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_attrs }
  end

  def then_grn_should_not_report_its_units
    expect(subject['status']).to eq('booked')
    expect(subject['delivered']).to eq(0)
    expect(subject['received']).to eq(0)
    expect(subject['goods_received_notice_events'].first['status']).to eq('booked')
    expect(subject['goods_received_notice_events'].first['received_at']).to_not be_present
    expect(subject['goods_received_notice_events'].first['cartons_received']).to eq(0)
    expect(subject['cartons_received']).to eq(0)
  end

  private

  let(:grn) { create(:goods_received_notice, :with_purchase_orders) }
  let(:grn_event) { grn.goods_received_notice_events.first }

  let(:grn_attrs) do
    { goods_received_notice_events_attributes: [{ id: grn_event.id, booked: true }] }
  end
end
