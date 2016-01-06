class Sku::Generator
  def generate(attrs)
    @attrs = attrs.with_indifferent_access
    sku = find_sku

    if sku.nil?
      sku = generate_new_sku
    end

    sku
  end

  private

  def attrs
    @attrs
  end

  def find_sku
    if attrs[:barcode].present?
      sku = find_sku_by_barcode
    else
      sku = find_sku_by_surfdome_size
    end

    if sku.nil?
      sku = find_sku_by_manufacturer_size
    end

    sku
  end

  def find_sku_by_barcode
    barcode = Barcode.find_by(barcode: attrs[:barcode])
    return nil unless barcode.present?
    Sku.find_by(sku: barcode.sku)
  end

  def find_sku_by_surfdome_size
    Sku.find_by(manufacturer_sku: attrs[:manufacturer_sku],
                size: attrs[:size])
  end

  def find_sku_by_manufacturer_size
    Sku.find_by(manufacturer_sku: attrs[:manufacturer_sku],
                manufacturer_size: attrs[:manufacturer_size])
  end

  def generate_new_sku
    sku = Sku.create!(attrs.except(:lead_gender, :barcode)
                           .merge(gender: attrs[:lead_gender].try(:to_sym) || ''))
    create_barcode_for(sku)
    Sku::Exporter.new.export(sku)
    sku
  end

  def create_barcode_for(sku)
    return unless attrs[:barcode].present?
    Barcode.create(sku: sku, barcode: attrs[:barcode])
  end
end
