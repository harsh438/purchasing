feature 'SKU updating' do
  subject { JSON.parse(page.body) }

  scenario 'Showing SKU' do
    when_i_request_a_sku
    then_i_should_receive_the_skus_details
  end

  scenario 'Updating a SKU' do
    when_i_update_a_skus_cost
    then_the_updated_cost_should_be_be_shown
  end

  def when_i_request_a_sku
    visit sku_path(sku)
  end

  def then_i_should_receive_the_skus_details
    expect(subject).to include('sku' => sku.sku)
  end

  def when_i_update_a_skus_cost
    attrs = { cost_price: '100' }
    page.driver.post sku_path(sku), { _method: 'patch', sku: attrs }
  end

  def then_the_updated_cost_should_be_be_shown
    expect(subject['cost_price']).to eq('£100.00')
  end

  let(:sku) { create(:sku) }
end
