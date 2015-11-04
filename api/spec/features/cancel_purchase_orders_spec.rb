feature 'Cancelling purchase orders' do
  subject { JSON.parse(page.body) }
  let (:vendor) { create(:vendor) }

  before(:each) do
    create_list(:purchase_order, 20,
                status: 4,
                season: 'AW15',
                po_number: 123,
                delivery_date: Time.new(2013, 1, 1))

    create_list(:purchase_order, 16, :arrived,
                status: 5,
                season: 'SS14',
                po_number: 234,
                delivery_date: Time.new(2011, 1, 1))

    create_list(:purchase_order, 15,
                vendor: vendor,
                status: 2,
                season: 'SS15',
                po_number: 345,
                delivery_date: Time.new(2014, 1, 1))
  end

  scenario 'Cancelling a purchase order line item' do
    when_i_cancel_a_line_item
    then_the_line_item_should_be_cancelled
  end

  scenario 'Cancelling an entire purchase order' do
    when_i_cancel_an_entire_purchase_order
    then_the_entire_purchase_order_should_be_cancelled
  end

  def when_i_cancel_a_line_item
    page.driver.post "/api/cancel/#{PurchaseOrder.first.id}"
  end

  def then_the_line_item_should_be_cancelled
    expect(PurchaseOrder.first).to be_cancelled
    expect(PurchaseOrder.second).to_not be_cancelled
  end

  def when_i_cancel_an_entire_purchase_order
    page.driver.post "/api/cancel/#{PurchaseOrder.first.id}/order"
  end

  def then_the_entire_purchase_order_should_be_cancelled
    not_cancelled = PurchaseOrder.where.not(status: -1)
                                 .where.not(po_number: PurchaseOrder.first.po_number)

    items = PurchaseOrder.where(po_number: PurchaseOrder.first.po_number)
    items.each do |item|
      expect(item).to be_cancelled
    end

    not_cancelled.each do |item|
      expect(item).to_not be_cancelled
    end
  end
end
