feature 'Marking Purchase Order as delivered', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Marking PO as delivered' do
    when_a_purchase_order_is_delivered
    then_grn_should_be_marked_as_delivered
  end

  scenario 'Marking PO as delivered when it has already been received' do
    when_a_received_purchase_order_is_marked_as_delivered
    then_grn_should_remain_received
  end

  def when_a_purchase_order_is_delivered
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_attrs }
  end

  def then_grn_should_be_marked_as_delivered
    expect(subject['status']).to eq('delivered')
    expect(subject['delivered']).to eq(1)
    expect(subject['goods_received_notice_events'].first['status']).to eq('delivered')
  end

  def when_a_received_purchase_order_is_marked_as_delivered
    grn_event.received = true
    grn_event.save!
    page.driver.post goods_received_notice_path(grn), { _method: 'patch',
                                                        goods_received_notice: grn_attrs }
  end

  def then_grn_should_remain_received
    expect(subject['status']).to eq('received')
    expect(subject['delivered']).to eq(0)
    expect(subject['received']).to eq(1)
    expect(subject['goods_received_notice_events'].first['status']).to eq('received')
  end

  private

  let(:grn) { create(:goods_received_notice, :with_purchase_orders) }
  let(:grn_event) { grn.goods_received_notice_events.first }

  let(:grn_attrs) do
    { goods_received_notice_events_attributes: [{ id: grn_event.id, delivered: true }] }
  end
end
