feature 'Purchase Order Listing' do
  subject { JSON.parse(page.body) }

  scenario 'Listing POs for Vendor' do
    when_i_request_pos_for_vendor_id
    then_i_should_see_vendor_specific_pos
  end

  scenario 'Listing POs with barcodes only' do
    when_i_request_purchase_orders
    then_i_should_see_purchase_orders_with_all_barcodes_populated_only
  end

  def when_i_request_pos_for_vendor_id
    create_purchase_orders
    visit list_purchase_orders_path(vendor_id: vendor.id)
  end

  def then_i_should_see_vendor_specific_pos
    expect(subject.count).to eq(2)
    expect(subject.first).to match(a_hash_including('id'))
  end

  def when_i_request_purchase_orders
    create_purchase_orders
    create_barcodeless_purchase_orders
    visit list_purchase_orders_path(vendor_id: vendor.id)
  end

  def then_i_should_see_purchase_orders_with_all_barcodes_populated_only
    expect(subject.count).to eq(2)
  end

  private

  let(:vendor) { create(:vendor) }

  def create_purchase_orders
    create_list(:purchase_order_line_item, 3, :with_summary)
    create_list(:purchase_order_line_item, 2, :with_summary, :balance, vendor: vendor)
  end

  def create_barcodeless_purchase_orders
    line_item = create(:purchase_order_line_item, :with_summary,
                                                  :balance,
                                                  sku: create(:sku_without_barcode),
                                                  vendor: vendor)
    create(:purchase_order, line_items: [line_item])
  end
end
