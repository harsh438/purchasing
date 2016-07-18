feature 'Listing GRNs', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Listing GRNs between a date range' do
    when_i_request_grns_within_a_date_range
    then_i_should_be_provided_only_grns_between_that_range
  end

  scenario 'Listing GRNs with counts' do
    when_i_request_grns
    then_i_should_also_see_unit_carton_and_pallet_counts
  end

  scenario 'Listing days that do not have GRNs' do
    when_i_request_a_date_range_that_includes_days_without_grns
    then_i_should_see_empty_days
  end

  scenario 'Listing GRNs without POs younger than 1 day' do
    when_i_request_grns_some_of_which_do_not_have_purchase_orders
    then_i_should_only_see_grns_created_within_last_day
  end

  scenario 'Listing GRNs with certain POs' do
    when_i_request_grns_that_contain_certain_purchase_orders
    then_i_should_only_see_grns_that_contain_those_purchase_orders
  end

  def when_i_request_grns_within_a_date_range
    create_grns
    visit goods_received_notices_path(start_date: 3.weeks.ago,
                                      end_date: 2.weeks.from_now)
  end

  def then_i_should_be_provided_only_grns_between_that_range
    expect(subject).to_not match(a_hash_including(4.weeks.ago.beginning_of_week.to_date.to_s))
    expect(subject).to_not match(a_hash_including(4.weeks.from_now.beginning_of_week.to_date.to_s))
    expected_hash = a_hash_including('week_num', 'start', 'end', 'notices_by_date')
    expect(subject).to include(Date.today.beginning_of_week.to_s => expected_hash)
  end

  def when_i_request_grns
    create_grns
    visit goods_received_notices_path(start_date: 3.weeks.ago,
                                      end_date: 2.weeks.from_now)
  end

  def then_i_should_also_see_unit_carton_and_pallet_counts
    expect(subject.values.first).to match(a_hash_including('units', 'cartons', 'pallets'))
  end

  def when_i_request_a_date_range_that_includes_days_without_grns
    create_list(:goods_received_notice, 2, delivery_date: Date.today)
    visit goods_received_notices_path(start_date: 2.weeks.ago,
                                      end_date: 2.days.from_now)
  end

  def then_i_should_see_empty_days
    expect(subject).to match(a_hash_including(last_monday.to_date.to_s))
  end

  def when_i_request_grns_some_of_which_do_not_have_purchase_orders
    create_grns_with_some_created_in_last_day
    visit goods_received_notices_path(start_date: 2.days.ago,
                                      end_date: 2.days.from_now)
  end

  def then_i_should_only_see_grns_created_within_last_day
    on_weekend_today = Date.today.saturday? || Date.today.sunday?
    unless on_weekend_today
      grns = subject.values.reduce({}) { |dates, week| dates.merge(week['notices_by_date']) }[Date.today.to_s]['notices']
      expect(grns).to include(a_hash_including('id' => grns_younger_than_one_day.first.id))
      expect(grns).to_not include(a_hash_including('id' => grns_older_than_one_day.first.id))
      expect(grns).to_not include(a_hash_including('id' => grns_older_than_one_day.second.id))
    end
  end

  def when_i_request_grns_that_contain_certain_purchase_orders
    grn_with_certain_po
    visit goods_received_notices_path(start_date: 2.weeks.ago,
                                      end_date: 2.days.from_now,
                                      purchase_order_id: po_belonging_to_certain_grn.id)
  end

  def then_i_should_only_see_grns_that_contain_those_purchase_orders
    grns = subject.values.reduce({}) { |dates, week| dates.merge(week['notices_by_date']) }[Date.today.to_s]['notices']
    expect(grns.count).to eq(1)
  end

  private

  let(:grns_older_than_one_day) do
    create_list(:goods_received_notice, 2, booked_in_at: 2.days.ago,
                                           delivery_date: Date.today)
  end

  let(:grns_younger_than_one_day) do
    create_list(:goods_received_notice, 2, booked_in_at: 2.hours.ago,
                                           delivery_date: Date.today)
  end

  let(:grn_with_certain_po) do
    create_list(:goods_received_notice, 3, :with_purchase_orders, delivery_date: Date.today)
  end

  let(:po_belonging_to_certain_grn) do
    grn_with_certain_po.first.purchase_orders.first
  end

  def last_monday
    if Date.today.monday?
      1.week.ago
    else
      Date.today.beginning_of_week
    end
  end

  def create_grns
    create_list(:goods_received_notice, 2, delivery_date: 4.weeks.ago)
    create_list(:goods_received_notice, 2, delivery_date: 4.weeks.from_now)
    create_list(:goods_received_notice, 2, delivery_date: Date.today)
  end

  def create_grns_with_some_created_in_last_day
    grns_younger_than_one_day
    grns_older_than_one_day
  end
end
