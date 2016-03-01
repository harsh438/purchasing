feature 'Updating barcodes' do
  subject { JSON.parse(page.body) }

  scenario 'Updating existing barcode' do
    when_i_update_an_existing_barcode_by_barcode_id
    then_the_barcode_should_be_updated
  end

  scenario 'Updating existing barcode with conflict' do
    when_i_update_an_existing_barcode_with_conflict
    then_the_barcode_should_not_be_updated
  end

  def when_i_update_an_existing_barcode_by_barcode_id
    purchase_order_line_item
    page.driver.post barcode_path(barcode), {
      _method: 'PATCH',
      barcode: new_barcode
    }
  end

  def then_the_barcode_should_be_updated
    expect(subject['barcodes'].count).to eq(1)
    expect(subject['barcodes'][0]['id']).to eq(barcode.id)
    expect(subject['barcodes'][0]['barcode']).to eq(new_barcode)
    and_legacy_barcode_should_also_be_updated
  end

  def and_legacy_barcode_should_also_be_updated
    po = PurchaseOrderLineItem.find(purchase_order_line_item.id)
    expect(po.orderTool_barcode).to eq(new_barcode)
  end

  def when_i_update_an_existing_barcode_with_conflict
    purchase_order_line_item
    page.driver.post barcode_path(barcode), {
      _method: 'PATCH',
      barcode: barcode.barcode
    }
  end

  def then_the_barcode_should_not_be_updated
    expect(page).to have_http_status(409)
    expect(subject['message']).to include("duplication")
    expect(subject['duplicated_sku']['id']).to eq(sku.id)
    expect(subject['duplicated_sku']['sku']).to eq(sku.sku)
  end

  let(:product_with_skus) { create(:product, :with_skus) }
  let(:sku) { product_with_skus.skus.first }
  let(:barcode) { sku.barcodes.first }
  let(:new_barcode) { Faker::Lorem.characters(15) }
  let(:purchase_order_line_item) { create(:purchase_order_line_item, sku_id: sku.id) }
end
