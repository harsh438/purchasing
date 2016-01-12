feature 'SKU generation' do
  subject { JSON.parse(page.body).with_indifferent_access }

  scenario 'Generating skus with a barcode' do
    when_i_generate_skus_with_a_barcode
    then_both_skus_and_legacy_records_should_be_generated
  end

  scenario 'Generating a single-size sku' do
    when_i_generate_a_single_size_sku_with_a_barcode
    then_no_legacy_option_should_be_generated
  end

  scenario 'Generating skus without a barcode' do
    when_i_generate_skus_without_a_barcode
    then_only_skus_should_be_generated
  end

  scenario 'Finding an existing sku by barcode and season' do
    when_i_try_to_generate_a_sku_with_an_existing_barcode_and_season
    then_it_should_return_the_existing_sku
  end

  scenario 'Finding an existing sku by reference and season' do
    when_i_try_to_generate_a_sku_with_season_but_no_barcode
    then_it_should_return_the_existing_sku_with_no_barcode
  end

  scenario 'Ensuring existing skus are not updated' do
    when_i_provide_new_attributes_for_a_sku
    then_the_sku_should_not_be_updated
  end

  scenario 'Adding SKU for new size of existing product' do
    when_i_create_a_sku_for_a_new_size_of_product
    then_the_sku_should_link_to_existing_legacy_product_and_create_new_size
  end

  def when_i_generate_a_single_size_sku_with_a_barcode
    page.driver.post skus_path(single_size_sku_attrs)
  end

  def when_i_generate_skus_with_a_barcode
    page.driver.post skus_path(sku_with_barcode_attrs)
  end

  def when_i_generate_skus_without_a_barcode
   page.driver.post skus_path(sku_with_no_barcode_attrs)
  end

  def then_no_legacy_option_should_be_generated
    check_correct_skus(single_size_sku_attrs)

    expect(subject[:sku]).to eq(Product.first.id.to_s)
    expect(single_size_sku_attrs[:barcode]).to eq(sku.barcodes.first.barcode)

    expect(sku.product).to be_a(Product)
    expect(sku.language_product).to be_a(LanguageProduct)
    expect(sku.language_product_option).to eq(nil)
    expect(sku.element).to eq(nil)
    expect(sku.option).to eq(nil)
    expect(sku.language_category).to be_a(LanguageCategory)
  end

  def then_both_skus_and_legacy_records_should_be_generated
    check_correct_skus(sku_with_barcode_attrs)

    expect(subject[:sku]).to eq("#{Product.first.id}-#{Element.first.id}")
    expect(sku_with_barcode_attrs[:barcode]).to eq(sku.barcodes.first.barcode)

    expect(sku.product).to be_a(Product)
    expect(sku.language_product).to be_a(LanguageProduct)
    expect(sku.language_product_option).to be_a(LanguageProductOption)
    expect(sku.element).to be_a(Element)
    expect(sku.option).to be_a(Option)
    expect(sku.language_category).to be_a(LanguageCategory)
  end

  def then_only_skus_should_be_generated
    check_correct_skus(sku_with_no_barcode_attrs)

    expect(subject[:sku]).to eq(sku_with_no_barcode_attrs[:sku])

    expect(sku.product).to be(nil)
    expect(sku.language_product).to be(nil)
    expect(sku.language_product_option).to be(nil)
    expect(sku.element).to be(nil)
    expect(sku.option).to be(nil)
    expect(sku.language_category).to be(nil)
  end

  def when_i_try_to_generate_a_sku_with_an_existing_barcode_and_season
    page.driver.post skus_path(existing_barcode_and_season_sku_attrs)
  end

  def then_it_should_return_the_existing_sku
    expect(subject[:id]).to eq(existing_sku.id)
  end

  def when_i_try_to_generate_a_sku_with_season_but_no_barcode
    page.driver.post skus_path(existing_season_sku_attrs)
  end

  def then_it_should_return_the_existing_sku_with_no_barcode
    expect(subject[:id]).to eq(existing_sku_without_barcode.id)
  end

  def when_i_provide_new_attributes_for_a_sku
    page.driver.post skus_path(sku: existing_sku_without_barcode.sku,
                               season: existing_sku_without_barcode.season,
                               manufacturer_size: 'XX-Large')
  end

  def then_the_sku_should_not_be_updated
    expect(subject[:manufacturer_size]).to eq('biggish')
  end

  def when_i_create_a_sku_for_a_new_size_of_product
    existing_sku
    page.driver.post skus_path(sku_for_new_size_attrs)
  end

  def then_the_sku_should_link_to_existing_legacy_product_and_create_new_size
    expect(subject[:sku]).to_not eq(existing_sku.sku)
    expect(subject[:sku]).to start_with(existing_sku.product_id.to_s)
    expect(subject[:product_id]).to eq(existing_sku.product_id)
    expect(subject[:option_id]).to_not eq(existing_sku.option_id)
  end

  private

  def check_correct_skus(attrs)
    attrs.except(:cost_price,
                 :price,
                 :lead_gender,
                 :category_id,
                 :category_name,
                 :barcode).each do |key, a|
      expect(subject[key]).to eq(a)
    end

    expect(sku.gender).to eq(base_sku_attrs[:lead_gender])
  end

  let(:base_sku_attrs) { { manufacturer_sku: 'DA-ADFADET-WHT',
                           manufacturer_color: 'Pale Blue',
                           manufacturer_size: '12',
                           season: 'ss15',
                           color: 'Blue',
                           size: '06-9 mths',
                           cost_price: 12.06,
                           price: 18.00,
                           lead_gender: 'M',
                           product_name: 'Clarks Originals Boots - Clarks Originals BabyWarm - Pale Blue',
                           vendor_id: 919,
                           category_id: 12,
                           category_name: 'Whatever',
                           inv_track: 'O' } }

  let(:existing_barcode_and_season_sku_attrs) { base_sku_attrs.merge(barcode: existing_sku.barcodes.first.barcode,
                                                                     season: existing_sku.season) }
  let(:existing_season_sku_attrs) { base_sku_attrs.merge(season: existing_sku_without_barcode.season) }
  let(:single_size_sku_attrs) { base_sku_attrs.merge(barcode: '12223892123', inv_track: 'P') }
  let(:sku_with_barcode_attrs) { base_sku_attrs.merge(barcode: '121389123') }
  let(:sku_with_no_barcode_attrs) { base_sku_attrs.merge(sku: 'NEGATIVE-EXAMPLE') }
  let(:sku_for_new_size_attrs) { base_sku_attrs.merge(season: existing_sku.season,
                                                      manufacturer_sku: existing_sku.manufacturer_sku,
                                                      manufacturer_color: existing_sku.manufacturer_color,
                                                      barcode: '1213891231') }

  let(:sku) { Sku.find_by(sku: subject[:sku]) }
  let(:existing_sku) { create(:sku) }
  let(:existing_sku_without_barcode) { create(:sku_without_barcode) }
end
