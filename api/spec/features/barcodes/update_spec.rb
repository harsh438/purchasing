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

  scenario 'Can edit barcode of unsized sku' do
    when_i_update_an_existing_barcode_from_an_unsized_sku
    then_the_api_should_not_returned_unsized_sku_error
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
    and_the_sku_should_be_touched
  end

  def and_legacy_barcode_should_also_be_updated
    po = PurchaseOrderLineItem.find(purchase_order_line_item.id)
    expect(po.orderTool_barcode).to eq(new_barcode)
    expect(sku.reload.barcodes[0].barcode).to eq(sku.option.barcode)
  end

  def and_the_sku_should_be_touched
    expect((sku.updated_at - Time.now).abs < 5).to be(true)
  end

  def when_i_update_an_existing_barcode_with_conflict
    sku_2
    page.driver.post barcode_path(barcode), {
      _method: 'PATCH',
      barcode: sku_2.barcodes[0].barcode
    }
  end

  def then_the_barcode_should_not_be_updated
    expect(page).to have_http_status(409)
    expect(subject['message']).to include('duplication')
    expect(subject['duplicated_sku']['id']).to eq(sku_2.id)
    expect(subject['duplicated_sku']['sku']).to eq(sku_2.sku)
  end

  def when_i_update_an_existing_barcode_from_an_unsized_sku
    page.driver.post barcode_path(unsized_sku_barcode), {
      _method: 'PATCH',
      barcode: random_barcode
    }
  end

  def then_the_api_should_not_returned_unsized_sku_error
    expect(page).to have_http_status(200)
  end

  def random_barcode
    Faker::Lorem.characters(8)
  end

  let(:product_with_skus) { create(:product, :with_skus) }
  let(:sku) { product_with_skus.skus.first }
  let(:unsized_sku) { create(:base_sku, :with_product, :with_barcode) }
  let(:unsized_sku_barcode) { unsized_sku.barcodes.first }
  let(:barcode) { sku.barcodes.first }
  let(:new_barcode) { random_barcode }
  let(:purchase_order_line_item) { create(:purchase_order_line_item, sku_id: sku.id) }
  let(:sku_2) { create(:base_sku, :with_product, barcodes: [create(:barcode)]) }
end
