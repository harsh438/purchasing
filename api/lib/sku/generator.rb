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
      find_sku_by_barcode_and_season
    else
      find_sku_by_reference_and_season
    end
  end

  def find_sku_by_barcode_and_season
    Sku.joins(:barcodes).find_by(barcodes: { barcode: attrs[:barcode] },
                                 season: attrs[:season])
  end

  def find_sku_by_reference_and_season
    Sku.find_by(attrs.slice(:sku, :season))
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
