feature 'SKU generation' do
  include_context 'exisiting sized sku that\'s also in in PVX'

  subject { JSON.parse(page.body).with_indifferent_access }

  feature 'Exporting new size for existing product' do
    scenario 'when the new sku has the same barcode as the existing sku' do
      when_an_existing_sku_is_equivalent_but_for_the_size_and_season
      then_a_new_sku_should_be_made_on_the_same_product_id_with_different_size
      then_a_merge_job_should_be_created
    end
  end

  scenario 'Adding a SKU with the same size and barcode as an existing sku but with a new season' do
    when_an_existing_sku_is_equivalent_but_for_the_season
    then_a_new_sku_should_be_made_on_that_product_with_a_new_season
    then_a_merge_job_should_not_be_created
  end

  scenario 'Generating skus with a barcode' do
    when_i_generate_skus_with_a_barcode
    then_both_skus_and_legacy_records_should_be_generated
    then_a_merge_job_should_not_be_created
  end

  scenario 'Generating a single-size sku' do
    when_i_generate_a_single_size_sku_with_a_barcode
    then_no_legacy_option_should_be_generated
    then_a_merge_job_should_not_be_created
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

  scenario 'Adding SKU for new size without barcode' do
    when_i_create_a_sku_for_new_size_of_product_without_barcode
    then_a_new_sku_should_be_created_for_the_size
  end

  scenario 'Add SKU for existing product that does not already have language category' do
    when_i_create_a_sku_for_a_an_existing_product_without_language_category
    then_the_sku_created_should_have_a_language_category
  end

  private

  def when_an_existing_sku_is_equivalent_but_for_the_size_and_season
    expect(MergeJob.all.count).to eq 0
    expect do
      VCR.use_cassette 'sku_generation_spec_existing_sku_new_size_and_season' do
        page.driver.post skus_path(new_sku_attrs)
      end
    end.to change { Option.where(product_id: existing_sku.product.id).count }.by(1)
  end

  def then_a_new_sku_should_be_made_on_the_same_product_id_with_different_size
    expect(subject[:size]).to eq 'UK-7'
    expect(subject[:element_id]).not_to eq existing_sku.element.id
    expect(subject[:sku]).not_to eq existing_sku.sku
    expect(subject[:sku]).to start_with(existing_sku.product_id.to_s)
    expect(subject[:option_id]).not_to eq existing_sku.option.id
    expect(subject[:language_product_option_id]).not_to eq existing_sku.language_product_option.id
    expect(subject[:product_id]).to eq existing_sku.product.id
  end

  def when_an_existing_sku_is_equivalent_but_for_the_season
    VCR.use_cassette 'sku_generation_spec_new_season' do
      page.driver.post skus_path(existing_sku_with_new_season)
    end
  end

  def then_a_new_sku_should_be_made_on_that_product_with_a_new_season
    expect(subject[:element_id]).to eq existing_sku.element.id
    expect(subject[:sku]).to eq existing_sku.sku
    expect(subject[:sku]).to start_with(existing_sku.product_id.to_s)
    expect(subject[:option_id]).to eq existing_sku.option.id
    expect(subject[:language_product_option_id]).to eq existing_sku.language_product_option.id
    expect(subject[:product_id]).to eq existing_sku.product.id
    expect(subject[:season]).not_to eq existing_sku.season
  end

  def then_a_merge_job_should_not_be_created
    expect(MergeJob.all.count).to eq 0
  end

  def then_a_merge_job_should_be_created
    expect(MergeJob.all.count).to eq 1
  end

  def when_i_generate_skus_with_a_barcode
    VCR.use_cassette 'sku_generation_spec_skus_with_barcode' do
      page.driver.post skus_path(sku_with_barcode_attrs)
    end
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
    VCR.use_cassette 'sku_generation_single_size_sku_with_barcode' do
      page.driver.post skus_path(single_size_sku_attrs)
    end
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
                               season: existing_sku_without_barcode.season.nickname,
                               manufacturer_size: existing_sku_without_barcode.manufacturer_size,
                               manufacturer_color: 'Blue',
                               inv_track: 'O')
  end

  def then_the_sku_should_not_be_updated
    expect(subject[:manufacturer_size]).to eq('biggish')
  end

  def when_i_create_a_sku_for_new_size_of_product_without_barcode
    page.driver.post skus_path(sku_for_new_size_attrs_without_barcode)
  end

  def then_a_new_sku_should_be_created_for_the_size
    expect(subject[:id]).to_not eq(existing_sku.id)
    expect(subject[:manufacturer_size]).to eq(sku_for_new_size_attrs_without_barcode[:manufacturer_size])
  end

  def when_i_create_a_sku_for_a_an_existing_product_without_language_category
    VCR.use_cassette 'sku_generation_spec_sku_without_lang_cat' do
      page.driver.post skus_path(new_sku_for_product_without_language)
    end
  end

  def then_the_sku_created_should_have_a_language_category
    expect(subject[:category_id]).to_not be_nil
  end

  let(:sku) { Sku.find_by(sku: subject[:sku]) }

  let(:existing_sku_without_barcode) { create(:base_sku, :sized) }

  let(:new_size_sku_without_barcode) { create(:base_sku, :sized, sku: '-100000-16',
                                                                    manufacturer_size: '16') }
  let(:existing_sku_without_category_id) do
    create(:base_sku, :sized, :with_product, :with_barcode, category_id: nil)
  end

  let(:existing_sku_with_new_season) { new_sku_attrs.merge({ size: existing_sku.size }) }

  let(:language_category) { create(:language_category) }

  let(:base_sku_attrs) do
    { manufacturer_sku: 'DA-ADFADET-WHT',
      manufacturer_color: 'Pale Blue',
      manufacturer_size: '12',
      season: 'SS15',
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
      inv_track: 'O',
      order_tool_reference: 122222,
      product_type: 'Jacket',
      brand_product_name: 'CORE DOWN JACKET' }
  end

  let(:existing_barcode_and_season_sku_attrs) { base_sku_attrs.merge(barcode: existing_sku.barcodes.first.barcode,
                                                                     season: existing_sku.season.nickname) }

  let(:existing_season_sku_attrs) do
    base_sku_attrs.merge(season: existing_sku_without_barcode.season.nickname,
                         manufacturer_size: existing_sku_without_barcode.manufacturer_size,
                         internal_sku: existing_sku_without_barcode.sku)
  end

  let(:single_size_sku_attrs) { base_sku_attrs.merge(barcode: '12223892123', inv_track: 'P') }

  let(:sku_with_barcode_attrs) { base_sku_attrs.merge(barcode: '121389123') }

  let(:sku_with_no_barcode_attrs) { base_sku_attrs.merge(internal_sku: 'NEGATIVE-EXAMPLE') }

  let(:sku_for_new_size_attrs_without_barcode) do
    base_sku_attrs.merge(season: new_size_sku_without_barcode.season.nickname,
                         manufacturer_sku: new_size_sku_without_barcode.manufacturer_sku,
                         manufacturer_color: new_size_sku_without_barcode.manufacturer_color,
                         manufacturer_size: '16',
                         internal_sku: new_size_sku_without_barcode.sku)
  end

  let(:new_sku_for_product_without_language) do
    base_sku_attrs.merge(season: 'SS10',
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
    expect(subject[:order_tool_reference]).to eq(attrs[:order_tool_reference])
    expect(subject[:product_type]).to eq(attrs[:product_type])
    expect(subject[:brand_product_name]).to eq(attrs[:brand_product_name])
  end
end
