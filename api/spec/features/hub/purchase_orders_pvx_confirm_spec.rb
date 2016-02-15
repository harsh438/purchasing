feature 'PVX confirm API for the hub' do
  subject { JSON.parse(page.body) }

  scenario 'Confirmation of PVX' do
    when_i_confirm_that_a_purchase_order_was_sent_in_peoplevox
    then_it_should_be_removed_from_the_list
  end

  def when_i_confirm_that_a_purchase_order_was_sent_in_peoplevox
    page.driver.post pvx_confirm_hub_purchase_orders_path, {
      purchase_order: { id: purchase_order_list[0].id }, request_id: request_id
    }
  end

  def then_it_should_be_removed_from_the_list
    page.driver.post latest_hub_purchase_orders_path, {
      parameters: { timestamp_from: Date.yesterday.iso8601 }, request_id: request_id
    }
    expect(subject['purchase_orders'].count).to eq(4)
    expect(subject['purchase_orders'].map do |line_item|
      line_item['id']
    end).not_to eq(purchase_order_list[0].id)
  end

  let (:request_id) {
    'gxrjcvvu2h4kppijw04nf3hxvz8dc97w'
  }

  let (:purchase_order_list) do
    create_list(:purchase_order, 5, :with_line_items_with_barcode, :with_grn_events)
  end
end
