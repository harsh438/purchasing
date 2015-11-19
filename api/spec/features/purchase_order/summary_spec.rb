feature 'Purchase Order Summary' do
  subject { JSON.parse(page.body) }

  before(:each) do
    create_purchase_orders
  end

  scenario 'Listing summaries' do
    when_i_request_purchase_order_summaries
    then_i_should_see_summary_data
  end

  scenario 'Summaries with cancelled items that were balance' do
    given_i_have_an_order_which_had_balance_items_that_are_now_cancelled
    when_i_request_purchase_order_summaries_for_the_order_with_cancelled_items
    then_i_should_see_correct_totals
  end

  def when_i_request_purchase_order_summaries
    visit purchase_orders_path(season: 'AW15')
  end

  def then_i_should_see_summary_data
    expect(subject['summary']).to_not be_empty
  end

  def given_i_have_an_order_which_had_balance_items_that_are_now_cancelled
    @cancelled_item = create(:purchase_order_line_item, :with_product, quantity: 10, quantity_done: 5).cancel
    @delivered_item = create(:purchase_order_line_item, :with_product, quantity: 10, quantity_done: 10, status: 5)
    @purchase_order = create(:purchase_order, line_items: [@cancelled_item, @delivered_item],
                                              drop_date: 2.days.ago)
  end

  def when_i_request_purchase_order_summaries_for_the_order_with_cancelled_items
    visit purchase_orders_path(summary_id: @purchase_order.id)
  end

  def then_i_should_see_correct_totals
    ordered_quantity = subject['summary']['ordered_quantity'].to_i
    delivered_quantity = subject['summary']['delivered_quantity'].to_i
    cancelled_quantity = subject['summary']['cancelled_quantity'].to_i
    balance_quantity = subject['summary']['balance_quantity'].to_i

    expect(ordered_quantity).to eq(delivered_quantity + cancelled_quantity + balance_quantity)
    expect(ordered_quantity).to eq(@cancelled_item.quantity + @delivered_item.quantity)
  end

  private

  def create_purchase_orders
    create_list(:purchase_order_line_item,
                20,
                status: 4,
                season: 'AW15',
                delivery_date: Time.new(2013, 1, 1))

    create_list(:purchase_order_line_item,
                16,
                :arrived,
                status: 5,
                season: 'SS14',
                delivery_date: Time.new(2011, 1, 1))
  end
end
