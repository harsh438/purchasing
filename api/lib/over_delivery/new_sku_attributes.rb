class OverDelivery::NewSkuAttributes

  attr_reader :sku_attrs

  def initialize(sku, season)
    @sku_attrs = sku.attributes
    @season = season
  end

  def build
    sku_attrs['season'] = season
    sku_attrs['barcode'] = barcode
    sku_attrs['category_id'] = language_category.category_id
    sku_attrs['category_name'] = language_category.name
    sku_attrs['internal_sku'] = sku_attrs['sku']
    sku_attrs['lead_gender'] = sku_attrs['gender']
    sku_attrs['force_generate'] = true
    sku_attrs
  end

  private

  attr_reader :season, :language_category

  def language_category
    @language_category ||= LanguageCategory.find_by!(id: sku_attrs['category_id'])
  end

  def barcode
    Barcode.find_by!(sku_id: sku_attrs['id']).barcode
  end
end
