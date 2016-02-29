feature 'SKU generation by PID' do
  subject { JSON.parse(page.body) }

  scenario 'Generating skus with an non_existent PID should fail' do
    when_i_generate_from_an_non_existent_pid
    then_the_api_should_return_404
  end

  scenario 'Generating skus with PID' do
    when_i_generate_sku_from_pid
    then_the_api_should_return_a_new_copied_sku
  end

  def when_i_generate_from_an_non_existent_pid
    page.driver.post create_by_pid_skus_path, { sku: { product_id: non_existent_pid } }
  end

  def then_the_api_should_return_404
    expect(page.driver.status_code).to be(404)
  end

  def when_i_generate_sku_from_pid
    page.driver.post create_by_pid_skus_path, {
      sku: {
        product_id: product_with_skus.id,
        element_id: element.id
      }
    }
  end

  def then_the_api_should_return_a_new_copied_sku
    expect(subject['sku']).to eq("#{product_with_skus.id}-#{element.name}")
    expect(subject['size']).to eq(element.name)
    expect(subject['manufacturer_size']).to eq(nil)
    expect(subject['id']).not_to eq(product_with_skus.skus.last.id)
    expect(subject['manufacturer_sku']).to eq(product_with_skus.skus.last.manufacturer_sku)
  end

  let(:product_with_skus) { create(:product, :with_skus) }
  let(:element) { create(:element) }
  let(:non_existent_pid) { 999999999 }
end
