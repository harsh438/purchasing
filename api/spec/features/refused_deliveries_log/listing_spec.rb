feature 'Listing Refused Deliveries Log', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Listing Refused Deliveries for date range' do
    when_i_request_refused_deliveries_for_date_range
    then_i_should_only_see_refused_deliveries_due_between_given_dates
  end

  def when_i_request_refused_deliveries_for_date_range
    create_refused_deliveries
    visit refused_deliveries_logs_path(date_from: 1.day.ago, date_to: Date.today)
  end

  def then_i_should_only_see_refused_deliveries_due_between_given_dates
    expect(subject.count).to eq(3)
  end

  private

  let(:vendor) { create(:vendor) }

  def create_refused_deliveries
    create_list(:refused_deliveries_log, 2, delivery_date: 2.days.ago,
                                            brand_id: vendor.venID)
    create_list(:refused_deliveries_log, 3, delivery_date: Date.today,
                                            brand_id: vendor.venID)
  end
end
