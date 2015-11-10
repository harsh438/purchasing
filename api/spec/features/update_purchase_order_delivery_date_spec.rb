feature 'Update Purchase Order Delivery Date' do
  let(:original_date) { Time.new(2013, 1, 1) }
  let(:new_date) { Time.new(1980, 1, 1) }

  before(:each) do
    create_list(:purchase_order, 3,
           delivery_date: original_date)
  end

  scenario 'Update Delivery Dates' do
    when_i_update_the_delivery_dates
    then_the_purchase_orders_should_have_a_new_delivery_date
  end

  def when_i_update_the_delivery_dates
    page.driver.post purchase_order_line_items_path(id: [PurchaseOrder.first, PurchaseOrder.second],
                                                    delivery_date: new_date)
  end

  def then_the_purchase_orders_should_have_a_new_delivery_date
    expect(PurchaseOrder.first.reload.delivery_date.to_time).to eq(new_date)
    expect(PurchaseOrder.second.reload.delivery_date.to_time).to eq(new_date)
    expect(PurchaseOrder.third.reload.delivery_date.to_time).to eq(original_date)
  end
end
