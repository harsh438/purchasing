feature 'SKU generation' do
  subject { JSON.parse(page.body).with_indifferent_access }

  scenario 'Generating skus with a barcode' do
    when_i_generate_skus_with_a_barcode
    then_both_skus_and_legacy_records_should_be_generated
  end

  scenario 'Generating skus without a barcode' do
    when_i_generate_skus_without_a_barcode
    then_only_skus_should_be_generated
  end

  scenario 'Finding an existing sku by barcode' do
    #when_i_try_to_generate_a_sku_with_an_existing_barcode
    #then_it_should_return_the_existing_sku
  end

  def when_i_generate_skus_with_a_barcode
    page.driver.post skus_path(sku_with_barcode_attrs)
  end

  def when_i_generate_skus_without_a_barcode
    page.driver.post skus_path(sku_with_no_barcode_attrs)
  end

  def then_both_skus_and_legacy_records_should_be_generated
    check_correct_skus

    expect(subject[:sku]).to eq("#{Product.first.id}-#{Element.first.id}")
    expect(sku_with_barcode_attrs[:barcode]).to eq(Sku.find_by(sku: subject[:sku]).barcodes.first.barcode)

    expect(sku.product).to be_a(Product)
    expect(sku.language_product).to be_a(LanguageProduct)
    expect(sku.language_product_option).to be_a(LanguageProductOption)
    expect(sku.element).to be_a(Element)
    expect(sku.option).to be_a(Option)
    expect(sku.language_category).to be_a(LanguageCategory)
  end

  def then_only_skus_should_be_generated
    check_correct_skus

    expect(subject[:sku]).to eq(sku_with_no_barcode_attrs[:sku])

    expect(sku.product).to be(nil)
    expect(sku.language_product).to be(nil)
    expect(sku.language_product_option).to be(nil)
    expect(sku.element).to be(nil)
    expect(sku.option).to be(nil)
    expect(sku.language_category).to be(nil)
  end

  private

  def check_correct_skus
    sku_with_barcode_attrs.except(:cost_price,
                                  :price,
                                  :lead_gender,
                                  :category_id,
                                  :category_name,
                                  :inv_track,
                                  :barcode).each do |key, a|
      expect(subject[key]).to eq(a)
    end

    expect(sku.gender).to eq(base_sku_attrs[:lead_gender])
  end

  let (:base_sku_attrs) { { manufacturer_sku: 'DA-ADFADET-WHT',
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
                            inv_track: 'P' } }

  let (:sku_with_barcode_attrs) { base_sku_attrs.merge!({ barcode: '12389123' }) }
  let (:sku_with_no_barcode_attrs) { base_sku_attrs.merge!({ sku: 'NEGATIVE-EXAMPLE' }) }
  let (:sku) { Sku.find_by(sku: subject[:sku]) }
end
