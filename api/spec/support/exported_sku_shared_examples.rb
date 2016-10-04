RSpec.shared_examples 'an exported sku:' do
  it 'sized dependencies are not nil' do
    expect(subject.option).to_not be nil
    expect(subject.element).to_not be nil
    expect(subject.language_product_option).to_not be nil
  end

  it 'the new sku is on the same pid' do
    expect(subject.product.id).to eq existing_unsized_sku.product.id
  end
end
