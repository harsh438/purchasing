feature 'Listing Packing Lists', booking_db: true do
  subject { JSON.parse(page.body) }

  scenario 'Listing packing lists for date range' do
    when_i_request_packing_lists_for_date_range
    then_i_should_only_see_packing_lists_due_between_given_dates
  end

  def when_i_request_packing_lists_for_date_range
    create_packing_lists
    visit packing_lists_path(date_from: 1.day.ago, date_to: Date.today)
  end

  def then_i_should_only_see_packing_lists_due_between_given_dates
    expect(subject.count).to eq(3)
  end

  private

  def create_packing_lists
    create_list(:goods_received_notice, 2, :with_packing_list,
                                           :with_purchase_orders,
                                           delivery_date: 2.days.ago)
    create_list(:goods_received_notice, 3, :with_packing_list,
                                           :with_purchase_orders,
                                           delivery_date: Date.today)
  end
end
