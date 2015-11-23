feature 'Purchase Order Drop Number' do
  scenario 'Showing drop number for delivered PO' do
    given_there_have_been_previous_drops
    when_viewing_purchase_orders
    then_drop_numbers_should_be_shown
  end

  def given_there_have_been_previous_drops
    product = create(:product)

    create_list(:purchase_order_line_item,
                1,
                :with_option,
                :with_summary,
                status: 5,
                product: product,
                season: 'AW15',
                delivery_date: Time.new(2015, 11, 1))

    create_list(:purchase_order_line_item,
                1,
                :with_option,
                :with_summary,
                status: 5,
                product: product,
                season: 'AW15',
                delivery_date: Time.new(2015, 11, 2))
  end

  def when_viewing_purchase_orders
    visit purchase_order_line_items_path(season: 'AW15')
  end

  def then_drop_numbers_should_be_shown
    expect(page).to have_content('1/2')
    expect(page).to have_content('2/2')
  end
end
