feature 'SKU generation' do
  subject { JSON.parse(page.body).with_indifferent_access }

  let (:multi_size_attrs) { { manufacturer_sku: 'DA-ADFADET-WHT',
                              manufacturer_color: 'Pale Blue',
                              manufacturer_size: '12',
                              season: 'ss15',
                              color: 'Blue',
                              size: '06-9 mths',
                              cost_price: 12.06,
                              price: 18.00,
                              lead_gender: 'M',
                              product_name: 'Clarks Originals Boots - Clarks Originals Baby Warm - Pale Blue',
                              vendor_id: 919,
                              category_id: 12,
                              category_name: 'Whatever',
                              inv_track: 'P',
                              barcode: '12389123' } }

  scenario 'Generating skus using the API' do
    when_i_generate_skus
    then_correct_skus_should_be_generated
  end

  def when_i_generate_skus
    page.driver.post skus_path(multi_size_attrs)
  end

  def then_correct_skus_should_be_generated
    multi_size_attrs.except(:cost_price,
                            :price,
                            :lead_gender,
                            :category_id,
                            :category_name,
                            :inv_track,
                            :barcode).each do |key, a|
      expect(subject[key]).to eq(a)
    end

    expect(subject[:sku]).to eq("#{Product.first.id}-#{Element.first.id}")
    expect(subject[:language_product_id]).to eq(LanguageProduct.first.id)
    expect(multi_size_attrs[:barcode]).to eq(Sku.find_by(sku: subject[:sku]).barcodes.first.barcode)
  end
end
