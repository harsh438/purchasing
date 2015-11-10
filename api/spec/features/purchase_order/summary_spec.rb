feature 'Purchase Order Summary' do
  subject { JSON.parse(page.body) }

  before(:each) do
    create_purchase_orders
  end

  scenario 'Listing summaries' do
    when_i_request_purchase_order_summaries
    then_i_should_see_summary_data
  end

  def when_i_request_purchase_order_summaries
    visit purchase_orders_path(season: 'AW15')
  end

  def then_i_should_see_summary_data
    expect(subject['summary']).to_not be_empty
  end

  private

  def create_purchase_orders
    create_list(:purchase_order, 20,
                status: 4,
                season: 'AW15',
                delivery_date: Time.new(2013, 1, 1))

    create_list(:purchase_order, 16, :arrived,
                status: 5,
                season: 'SS14',
                delivery_date: Time.new(2011, 1, 1))
  end
end
