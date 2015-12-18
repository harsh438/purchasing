feature 'Listing GRNs' do
  subject { JSON.parse(page.body) }

  scenario 'Listing GRNs between a date range' do
    when_i_request_a_grns_within_a_date_range
    then_i_should_be_provided_only_grns_between_that_range
  end

  scenario 'Listing GRNs with counts' do
    when_i_request_a_grns
    then_i_should_also_see_unit_carton_and_pallet_counts
  end

  def when_i_request_a_grns_within_a_date_range
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

  def when_i_request_a_grns
    create_grns
    visit goods_received_notices_path(start_date: 3.weeks.ago,
                                      end_date: 2.weeks.from_now)
  end

  def then_i_should_also_see_unit_carton_and_pallet_counts
    expect(subject.values.first).to match(a_hash_including('units', 'cartons', 'pallets'))
  end

  private

  def create_grns
    create_list(:goods_received_notice, 2, delivery_date: 4.weeks.ago)
    create_list(:goods_received_notice, 2, delivery_date: 4.weeks.from_now)
    create_list(:goods_received_notice, 2, delivery_date: Date.today)
  end
end
