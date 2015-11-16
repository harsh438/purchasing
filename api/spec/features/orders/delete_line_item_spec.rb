feature 'Delete Order Line Item' do
  let(:line_item) { create(:order_line_item) }

  scenario 'Delete Order Line Item' do
    when_i_delete_the_line_item
    then_there_should_be_0_line_items
  end

  def when_i_delete_the_line_item
    page.driver.post(order_line_item_path(id: line_item), _method: 'DELETE')
  end

  def then_there_should_be_0_line_items
    expect(OrderLineItem.count).to be(0)
  end
end
