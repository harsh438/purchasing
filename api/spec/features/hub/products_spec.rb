feature 'Requesting products ready for import' do
  scenario 'with products needing import' do
    given_a_product_has_been_updated
    when_requesting_products_to_import
    the_updated_product_is_returned
    the_payload_matches 'spec/fixtures/responses/single_product.json'
  end

  def subject
    JSON.parse(page.body)
  end

  def setup_skus
    sized_product.skus << create(
      :base_sku, :with_product,
      :with_barcode, :sized,
      vendor: sized_product.vendor,
      size: 'small',
      product: sized_product,
      product_name: 'Incredible Iron Pants',
      barcode: create(:barcode, barcode: 'ABC123456'),
    )
    sized_product.skus << create(
      :base_sku, :with_product,
      :with_barcode, :sized,
      vendor: sized_product.vendor,
      size: 'small',
      product: sized_product,
      product_name: 'Incredible Iron Pants',
      barcode: create(:barcode, :week_old, barcode: 'ABC123457'),
    )
    sized_product.skus << create(
      :base_sku, :with_product,
      :sized,
      vendor: sized_product.vendor,
      size: 'small',
      product: sized_product,
      product_name: 'Incredible Iron Pants',
    )
  end

  def setup_images
    sized_product.product_images << create(
      :product_image,
      deleted_at: nil,
      its_reference: 'awesome@photo',
    )

    sized_product.product_images << create(
      :product_image,
      deleted_at: Time.zone.now,
      its_reference: 'crappy@photo',
    )
  end

  def given_a_product_has_been_updated
    setup_skus
    setup_images

    sized_product.skus.update_all(updated_at: Time.parse('2016-07-21T14:39:48.000Z'))
    sized_product.update_column(:updated_at, Time.parse('2016-07-21T14:39:48.000Z'))
  end

  def when_requesting_products_to_import
    page.driver.post latest_hub_products_path, {
      request_id: request_id,
      parameters: {
        import_size: 40,
        last_imported_id: 0,
        last_imported_timestamp: Time.parse('2016-07-21T14:34:48.000Z').iso8601,
      }
    }
  end

  def the_updated_product_is_returned
    expect(subject['products'].map { |p| p['id'] }).to include(sized_product.id)
  end

  def the_payload_matches file
    expect(JSON.pretty_generate(subject).strip).to eq(File.read(file).strip)
  end

  let(:vendor) { create(:vendor, name: 'Too Awesome', id: 8981) }

  let(:sized_product) do
    create(
      :product,

      :with_reporting_category,
      :with_pvx_in,
      :with_kit_managers,
      :with_gender,

      inv_track: 'O',
      product_images: build_list(:product_image, 2),
      dropshipment: 'D-R-P',
      reporting_category_name: 'Gerry Treutel',
      price: 15.99,
      cost: 8.17,
      vendor: vendor,
      manufacturer_sku: '123456-123',
      color: 'blue',
      name: [vendor.name, 'Boots \'n\' Tings', 'blue'].join(' - '),
      teaser: 'utilize best-of-breed partnerships',
      barcode: 'ABC123456',
      season: Season.find_by(SeasonNickname: 'SS17'),
      gender: 'T',
    )
  end

  let!(:related_product) do
    create(
      :product,
      vendor: vendor,
      color: "green",
      name: [vendor.name, 'Boots \'n\' Tings', 'green'].join(' - '),
    )
  end

  let!(:negative_product) do
    create(:product, :with_reporting_category, barcode: '').tap do |p|
      p.skus += create_list(:base_sku, 2, :sized)
    end
  end

  let(:request_id) { 'n3nuea8nvr13ugy' }
end
