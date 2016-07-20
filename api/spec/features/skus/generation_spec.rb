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

  scenario 'Adding SKU for new size of existing product with barcode' do
    when_i_create_a_sku_for_a_new_size_of_product_with_barcode
    then_the_sku_should_link_to_existing_legacy_product_and_create_new_size
  end

  scenario 'Adding SKU for new size without barcode' do
    when_i_create_a_sku_for_new_size_of_product_without_barcode
    then_a_new_sku_should_be_created_for_the_size
  end

  scenario 'Add SKU for existing product that does not already have language category' do
    when_i_create_a_sku_for_a_an_existing_product_without_language_category
    then_the_sku_created_should_have_a_language_category
  end

  def when_i_generate_skus_with_a_barcode
    page.driver.post skus_path(sku_with_barcode_attrs)
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

  def when_i_generate_a_single_size_sku_with_a_barcode
    page.driver.post skus_path(single_size_sku_attrs)
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

  def when_i_generate_skus_without_a_barcode
   page.driver.post skus_path(sku_with_no_barcode_attrs)
  end

  def then_only_skus_should_be_generated
    check_correct_skus(sku_with_no_barcode_attrs)

    expect(subject[:sku]).to eq(sku_with_no_barcode_attrs[:internal_sku])

    expect(sku.product).to be(nil)
    expect(sku.language_product).to be(nil)
    expect(sku.language_product_option).to be(nil)
    expect(sku.element).to be(nil)
    expect(sku.option).to be(nil)
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
    page.driver.post skus_path(internal_sku: existing_sku_without_barcode.sku,
                               season: existing_sku_without_barcode.season,
                               manufacturer_size: existing_sku_without_barcode.manufacturer_size,
                               manufacturer_color: 'Blue')
  end

  def then_the_sku_should_not_be_updated
    expect(subject[:manufacturer_size]).to eq('biggish')
  end

  def when_i_create_a_sku_for_a_new_size_of_product_with_barcode
    page.driver.post skus_path(sku_for_new_size_attrs_with_barcode)
  end

  def then_the_sku_should_link_to_existing_legacy_product_and_create_new_size
    expect(subject[:sku]).to_not eq(existing_sku.sku)
    expect(subject[:sku]).to start_with(existing_sku.product_id.to_s)
    expect(subject[:product_id]).to eq(existing_sku.product_id)
    expect(subject[:option_id]).to_not eq(existing_sku.option_id)
  end

  def when_i_create_a_sku_for_new_size_of_product_without_barcode
    page.driver.post skus_path(sku_for_new_size_attrs_without_barcode)
  end

  def then_a_new_sku_should_be_created_for_the_size
    expect(subject[:id]).to_not eq(existing_sku.id)
    expect(subject[:manufacturer_size]).to eq(sku_for_new_size_attrs_without_barcode[:manufacturer_size])
  end

  def when_i_create_a_sku_for_a_an_existing_product_without_language_category
    page.driver.post skus_path(new_sku_for_product_without_language)
  end

  def then_the_sku_created_should_have_a_language_category
    expect(subject[:category_id]).to_not be_nil
  end

  private

  let(:sku) { Sku.find_by(sku: subject[:sku]) }

  let(:existing_sku) { create(:sku) }

  let(:existing_sku_without_barcode) { create(:sku_without_barcode) }

  let(:new_size_sku_without_barcode) { create(:sku_without_barcode, sku: '-100000-16',
                                                                    manufacturer_size: '16') }
  let(:existing_sku_without_category_id) { create(:sku, category_id: nil) }

  let(:language_category) { create(:language_category, :with_a_category) }

  let(:base_sku_attrs) do
    { manufacturer_sku: 'DA-ADFADET-WHT',
      manufacturer_color: 'Pale Blue',
      manufacturer_size: '12',
      season: 'ss15',
      color: 'Blue',
      size: '06-9 mths',
      cost_price: 12.06,
      price: 18.00,
      lead_gender: 'M',
      listing_genders: 'M',
      product_name: 'Clarks Originals Boots - Clarks Originals BabyWarm - Pale Blue',
      vendor_id: 919,
      category_id: language_category.category.id,
      category_name: language_category.name,
      inv_track: 'O' }
  end

  let(:existing_barcode_and_season_sku_attrs) { base_sku_attrs.merge(barcode: existing_sku.barcodes.first.barcode,
                                                                     season: existing_sku.season) }

  let(:existing_season_sku_attrs) do
    base_sku_attrs.merge(season: existing_sku_without_barcode.season,
                         manufacturer_size: existing_sku_without_barcode.manufacturer_size,
                         internal_sku: existing_sku_without_barcode.sku)
  end

  let(:single_size_sku_attrs) { base_sku_attrs.merge(barcode: '12223892123', inv_track: 'P') }

  let(:sku_with_barcode_attrs) { base_sku_attrs.merge(barcode: '121389123') }

  let(:sku_with_no_barcode_attrs) { base_sku_attrs.merge(internal_sku: 'NEGATIVE-EXAMPLE') }

  let(:sku_for_new_size_attrs_with_barcode) do
    base_sku_attrs.merge(season: existing_sku.season,
                         manufacturer_sku: existing_sku.manufacturer_sku,
                         manufacturer_color: existing_sku.manufacturer_color,
                         barcode: '1213891231')
  end

  let(:sku_for_new_size_attrs_without_barcode) do
    base_sku_attrs.merge(season: new_size_sku_without_barcode.season,
                         manufacturer_sku: new_size_sku_without_barcode.manufacturer_sku,
                         manufacturer_color: new_size_sku_without_barcode.manufacturer_color,
                         manufacturer_size: '16',
                         internal_sku: new_size_sku_without_barcode.sku)
  end

  let(:new_sku_for_product_without_language) do
    base_sku_attrs.merge(season: 'SS17',
                         barcode: existing_sku_without_category_id.barcodes.first.barcode)
  end

  def check_correct_skus(attrs)
    expect(subject[:manufacturer_sku]).to eq(attrs[:manufacturer_sku])
    expect(subject[:manufacturer_color]).to eq(attrs[:manufacturer_color])
    expect(subject[:manufacturer_size]).to eq(attrs[:manufacturer_size])
    expect(subject[:vendor_id]).to eq(attrs[:vendor_id])
    expect(subject[:product_name]).to eq(attrs[:product_name])
    expect(subject[:season]).to eq(attrs[:season])
    expect(subject[:color]).to eq(attrs[:color])
    expect(subject[:inv_track]).to eq(attrs[:inv_track])
    expect(subject[:category_id]).to eq(attrs[:category_id])
    expect(subject[:gender]).to eq(base_sku_attrs[:lead_gender])
    expect(subject[:listing_genders]).to eq(attrs[:listing_genders])
  end
end
