feature 'Uncancel Purchase Orders' do
  let(:cancelled_orders) do
    create_list(:purchase_order_line_item,
                2,
                status: -1,
                cancelled_date: Time.new(2013, 1, 1))
  end

  let(:non_cancelled_order) { create(:purchase_order_line_item, status: 3) }

  scenario 'Uncancelling cancelled Purchase Orders' do
    when_i_uncancel_cancelled_purchase_orders
    then_the_purchase_orders_should_be_uncancelled
  end

  scenario 'Uncancelled a non-cancelled Purchase Order' do
    when_i_uncancel_a_non_cancelled_purchase_order
    then_the_purchase_order_should_not_be_modified
  end

  def when_i_uncancel_cancelled_purchase_orders
    page.driver.post uncancel_purchase_order_line_items_path(id: [cancelled_orders.first, cancelled_orders.second])
  end

  def then_the_purchase_orders_should_be_uncancelled
    expect(cancelled_orders.first.reload.status).to eq(:new_po)
    expect(cancelled_orders.first.reload.status).to eq(:new_po)
  end

  def when_i_uncancel_a_non_cancelled_purchase_order
    page.driver.post uncancel_purchase_order_line_items_path(id: [non_cancelled_order])
  end

  def then_the_purchase_order_should_not_be_modified
    expect(non_cancelled_order.reload.status).to eq(:receiving)
  end
end
