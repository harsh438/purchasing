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
    expect(subject['manufacturer_size']).to eq(new_manufacturer_size)
    expect(sku.option.size).to eq(new_manufacturer_size)
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

  let(:new_manufacturer_size) { Faker::Lorem.characters(15) }
  let(:empty_manufacturer_size) { '    ' }
  let(:sku) { create(:sku) }
end
