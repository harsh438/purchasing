feature 'SKU duplication' do
  subject { JSON.parse(page.body) }

  scenario 'Generating skus with from a non-existent SKU should fail' do
    when_i_generate_from_an_non_existent_pid
    then_the_api_should_return_404
  end

  scenario 'Generating skus with PID' do
    when_i_generate_sku_from_pid
    then_the_api_should_return_a_new_copied_sku_with_pid
  end

  scenario 'Generating skus from sku without barcode should fail' do
    when_i_generate_sku_without_barcode
    then_the_api_should_refuse_the_sku_without_barcode
  end

  scenario 'Generating skus from unsized sku' do
    when_i_generate_unsized_sku
    then_the_api_should_refuse_the_unsized_sku
  end

  def when_i_generate_from_an_non_existent_pid
    page.driver.post duplicate_skus_path, { sku: { sku: non_existent_sku } }
  end

  def then_the_api_should_return_404
    expect(page.driver.status_code).to be(404)
  end

  def when_i_generate_sku_from_pid
    page.driver.post duplicate_skus_path, {
      sku: {
        sku: sku.sku,
        element_id: element.id
      }
    }
  end

  def then_the_api_should_return_a_new_copied_sku_with_pid
    expect(subject['sku']).to eq("#{product_with_skus.id}-#{element.id}")
    expect(subject['size']).to eq(element.name)
    expect(subject['manufacturer_size']).to eq(nil)
    expect(subject['id']).not_to eq(sku.id)
    expect(subject['manufacturer_sku']).to eq(sku.manufacturer_sku)
    expect(subject['product_id']).to eq(sku.product.id)
  end

  def when_i_generate_sku_without_barcode
    page.driver.post duplicate_skus_path, {
      sku: {
        sku: sku_without_barcode.sku,
        element_id: element.id
      }
    }
  end

  def then_the_api_should_refuse_the_sku_without_barcode
    expect(page.driver.status_code).to eq(422)
    expect(subject['message']).to eq('Please use a SKU with a barcode')
  end

  def when_i_generate_unsized_sku
    page.driver.post duplicate_skus_path, {
      sku: {
        sku: unsized_sku.sku,
        element_id: element.id
      }
    }
  end

  def then_the_api_should_refuse_the_unsized_sku
    expect(page.driver.status_code).to eq(422)
    expect(subject['message']).to eq('Please select a SKU with a size')
  end

  let(:product_with_skus) { sku.product }
  let(:sku) do
    create(
      :base_sku, :with_product, :sized, :with_barcode, sku: "#{product.id}-2222", product: product
    )
  end
  let(:product) { create(:product) }
  let(:sku_without_barcode) { create(:base_sku, :sized) }
  let(:unsized_sku) { create(:base_sku, :with_product, :with_barcode) }
  let(:element) { create(:element) }
  let(:non_existent_sku) { Faker::Lorem.characters(15) }
end
