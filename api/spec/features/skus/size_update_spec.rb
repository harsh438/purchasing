feature 'Editing manufacturer size' do
  subject { JSON.parse(page.body) }

  scenario 'Option is updated when editing manufacturer size' do
    when_i_update_manufacturer_size
    then_associated_option_should_be_updated
  end

  scenario 'Manufacturer size cannot be empty' do
    when_i_update_manufacturer_size_to_empty_string
    then_update_should_be_refused
  end

  scenario 'Manufacturer size cannot be empty except if it was empty before' do
    when_i_update_manufacturer_size_to_empty_string_with_empty_before
    then_associated_option_should_be_updated_to_nothing
  end

  def when_i_update_manufacturer_size
    page.driver.post sku_path(sku), {
      _method: 'PATCH',
      sku: {
        id: sku.id,
        manufacturer_size: new_manufacturer_size
      }
    }
  end

  def then_associated_option_should_be_updated
    expect(subject['manufacturer_size']).to eq(new_manufacturer_size.strip)
    sku_in_db = Sku.find_by(id: sku.id)
    expect(sku_in_db.option.size).to eq(new_manufacturer_size.strip)
  end

  def when_i_update_manufacturer_size_to_empty_string
    page.driver.post sku_path(sku), {
      _method: 'PATCH',
      sku: {
        id: sku.id,
        manufacturer_size: empty_manufacturer_size
      }
    }
  end

  def then_update_should_be_refused
    expect(page.driver.status_code).to eq(422)
    expect(subject['message']).to eq('Manufacturer size cannot be empty')
  end

  def when_i_update_manufacturer_size_to_empty_string_with_empty_before
    page.driver.post sku_path(sku_with_empty_size), {
      _method: 'PATCH',
      sku: {
        id: sku_with_empty_size.id,
        manufacturer_size: empty_manufacturer_size
      }
    }
  end

  def then_associated_option_should_be_updated_to_nothing
    expect(subject['manufacturer_size']).to eq(empty_manufacturer_size)
    sku = Sku.find_by(id: sku_with_empty_size.id)
    expect(sku.option.size).to eq(empty_manufacturer_size)
  end

  let(:new_manufacturer_size) { Faker::Lorem.characters(5) }
  let(:empty_manufacturer_size) { '    ' }
  let(:sku) { create(:base_sku, :sized, :with_product, :with_barcode) }
  let(:sku_with_empty_size) do create(
    :base_sku,
    :sized,
    :with_product,
    :with_barcode,
    manufacturer_size: nil)
  end
end
