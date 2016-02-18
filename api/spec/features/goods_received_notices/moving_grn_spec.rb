feature 'Moving GRN' do
  subject { JSON.parse(page.body) }

  scenario 'Changing delivery date of GRN' do
    when_changing_a_delivery_date_of_grn
    then_the_delivery_date_of_both_grn_and_events_should_be_updated
  end

  def when_changing_a_delivery_date_of_grn
    path = goods_received_notice_path(grn_with_pos)
    page.driver.post(path, _method: 'patch',
                           goods_received_notice: { delivery_date: new_delivery_date })
  end

  def then_the_delivery_date_of_both_grn_and_events_should_be_updated
    expect(subject).to include('delivery_date' => new_delivery_date)
    expect(subject['goods_received_notice_events'].first).to include('delivery_date' => new_delivery_date)
  end

  private

  let(:grn_with_pos) { create(:goods_received_notice, :with_purchase_orders) }
  let(:new_delivery_date) { 2.days.from_now.to_date.to_s }
end
