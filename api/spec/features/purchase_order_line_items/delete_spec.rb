feature 'Delete Purchase Order Line Item' do
  let(:line_item) { create(:purchase_order_line_item) }

  scenario 'Delete Line Item' do
    when_i_delete_the_line_item
    then_there_should_be_0_line_items
  end

  def when_i_delete_the_line_item
    page.driver.post delete_purchase_order_line_items_path(id: line_item)
  end

  def then_there_should_be_0_line_items
    expect(PurchaseOrderLineItem.count).to be(0)
  end
end
