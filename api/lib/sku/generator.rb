class Sku::Generator
  def generate(attrs)
    @attrs = attrs.with_indifferent_access
    find_sku || generate_new_sku
  end

  private

  def attrs
    @attrs
  end

  def find_sku
    if attrs[:barcode].present?
      find_sku_by_barcode_and_season
    else
      find_sku_by_reference_size_and_season
    end
  end

  def find_sku_by_barcode_and_season
    Sku.joins(:barcodes).find_by(barcodes: { barcode: attrs[:barcode] },
                                 season: attrs[:season])
  end

  def find_sku_by_reference_size_and_season
    Sku.find_by(sku: attrs[:internal_sku],
                manufacturer_size: attrs[:manufacturer_size],
                season: attrs[:season])
  end

  def generate_new_sku
    sku = Sku.create!(sku: attrs[:internal_sku],
                      manufacturer_sku: attrs[:manufacturer_sku],
                      manufacturer_color: attrs[:manufacturer_color],
                      manufacturer_size: attrs[:manufacturer_size],
                      vendor_id: attrs[:vendor_id],
                      product_name: attrs[:product_name],
                      season: attrs[:season],
                      color: attrs[:color],
                      size: attrs[:size],
                      color_family: attrs[:color_family],
                      size_scale: attrs[:size_scale],
                      cost_price: attrs[:cost_price],
                      list_price: attrs[:list_price],
                      price: attrs[:price],
                      inv_track: attrs[:inv_track],
                      gender: attrs[:lead_gender].try(:to_sym) || '',
                      category_id: find_or_create_language_category.id)
    create_barcode_for(sku)
    Sku::Exporter.new.export(sku)
    sku
  end

  def create_barcode_for(sku)
    return unless attrs[:barcode].present?
    Barcode.create(sku: sku, barcode: attrs[:barcode])
  end

  def find_or_create_language_category
    LanguageCategory.find_by!(language_id: 1,
                              name: attrs[:category_name],
                              category_id: attrs[:category_id])
  end
end
