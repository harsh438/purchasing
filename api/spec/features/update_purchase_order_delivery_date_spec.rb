feature 'Update Purchase Order Delivery Date' do
  let (:po) do
    create(:purchase_order,
           delivery_date: Time.new(2013, 1, 1))
  end

  let(:new_date) { Time.new(1980, 1, 1) }

  scenario 'Update Delivery Date' do
    when_i_update_the_delivery_date
    then_the_purchase_order_should_have_a_new_delivery_date
  end

  def when_i_update_the_delivery_date
    page.driver.post purchase_order_path(po), { delivery_date: new_date }
  end

  def then_the_purchase_order_should_have_a_new_delivery_date
    expect(po.reload.delivery_date.to_time).to eq(new_date)
  end
end
