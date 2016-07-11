class LegacyInformation
  def initialize(sku)
    @sku = sku
  end

  def as_json
    {
      legacy_lead_gender: legacy_lead_gender,
      legacy_reporting_category: legacy_reporting_category,
      legacy_breadcrumb_category: legacy_breadcrumb_category_id,
      legacy_season: legacy_season,
      legacy_supplier_sku: legacy_supplier_sku
    }
  end

  private

  attr_reader :sku

  def legacy_lead_gender
    @legacy_lead_gender ||= sku.gender
  end

  def legacy_reporting_category
    @legacy_reporting_category ||= sku.category_name
  end

  def legacy_breadcrumb_category_id
    @ordered_catid ||= sku.ordered_catid
  end

  def legacy_season
    @season ||= sku.season
  end

  def legacy_supplier_sku
    @man_sku ||= sku.manufacturer_sku
  end
end
