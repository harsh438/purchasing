feature 'Purchase Order Listing' do
  subject { JSON.parse(page.body) }

  scenario 'Listing POs for Vendor' do
    when_i_request_pos_for_vendor_id
    then_i_should_see_vendor_specific_pos
  end

  def when_i_request_pos_for_vendor_id
    create_purchase_orders
    visit list_purchase_orders_path(vendor_id: vendor.id)
  end

  def then_i_should_see_vendor_specific_pos
    expect(subject.count).to eq(2)
  end

  private

  let(:vendor) { create(:vendor) }

  def create_purchase_orders
    create_list(:purchase_order_line_item, 3, :with_summary)
    create_list(:purchase_order_line_item, 2, :with_summary, :balanced, vendor: vendor)
  end
end
