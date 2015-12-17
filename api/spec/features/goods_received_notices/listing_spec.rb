feature 'Listing GRNs' do
  subject { JSON.parse(page.body) }

  scenario 'Listing out between a date range' do
    when_i_request_a_grns_within_a_date_range
    then_i_should_be_provided_only_grns_between_that_range
  end

  def when_i_request_a_grns_within_a_date_range
    create_list(:goods_received_notice, 2, delivery_date: 4.weeks.ago)
    create_list(:goods_received_notice, 2, delivery_date: 4.weeks.from_now)
    create_list(:goods_received_notice, 2, delivery_date: Date.today)
    visit goods_received_notices_path(start_date: 3.weeks.ago,
                                      end_date: 2.weeks.from_now)
  end

  def then_i_should_be_provided_only_grns_between_that_range
    expect(subject).to_not include(a_hash_including('delivery_date' => 4.weeks.ago.to_date.to_s))
    expect(subject).to_not include(a_hash_including('delivery_date' => 4.weeks.from_now.to_date.to_s))
    expect(subject).to include(a_hash_including('delivery_date' => Date.today.to_s))
  end
end
