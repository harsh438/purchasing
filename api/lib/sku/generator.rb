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
      find_sku_by_reference_and_season
    end
  end

  def find_sku_by_barcode_and_season
    Sku.joins(:barcodes).find_by(barcodes: { barcode: attrs[:barcode] },
                                 season: attrs[:season])
  end

  def find_sku_by_reference_and_season
    Sku.find_by(sku: attrs[:internal_sku], season: attrs[:season])
  end

  def generate_new_sku
    sku = Sku.create!(attrs.except(:lead_gender, :barcode)
                           .merge(gender: attrs[:lead_gender].try(:to_sym) || '')
                           .merge(category_id: find_or_create_language_category.id))
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
