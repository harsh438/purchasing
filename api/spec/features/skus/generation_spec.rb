feature 'SKU generation' do
  subject { JSON.parse(page.body) }

  scenario 'Generating skus from a product with multiple sizes' do
    when_i_generate_a_sku_from_a_multi_sized_product
    then_each_corresponding_option_should_create_a_sku
  end

  scenario 'Generating a sku from a product with one size' do
    when_i_generate_a_sku_from_a_single_sized_product
    then_the_generated_sku_should_be_valid
  end

  def when_i_generate_a_sku_from_a_multi_sized_product

  end

  def then_each_corresponding_option_should_create_a_sku

  end

  def when_i_generate_a_sku_from_a_single_sized_product

  end

  def then_the_generated_sku_should_be_valid

  end
end
