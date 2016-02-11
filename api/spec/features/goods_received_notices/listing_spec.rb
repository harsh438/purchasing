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

  scenario 'Hiding GRNs without POs older than 1 hour' do
    when_i_request_grns_some_of_which_do_not_have_purchase_orders
    then_i_should_only_see_grns_created_within_last_hour
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
    create_grns_with_some_created_in_last_hour
    visit goods_received_notices_path(start_date: 1.day.ago,
                                      end_date: 2.days.from_now)
  end

  def then_i_should_only_see_grns_created_within_last_hour
    grns = subject.values.first['notices_by_date'][Date.today.to_s]['notices']
    expect(grns).to_not include(a_hash_including('id' => grns_older_than_last_hour.first.id))
    expect(grns).to_not include(a_hash_including('id' => grns_older_than_last_hour.second.id))
  end

  private

  let(:grns_older_than_last_hour) do
    create_list(:goods_received_notice, 2, booked_in_at: 2.hours.ago,
                                           delivery_date: Date.today)
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

  def create_grns_with_some_created_in_last_hour
    create_grns
    grns_older_than_last_hour
  end
end
