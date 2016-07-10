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
    ProductCategory.joins(:category)
                    .where(pID: sku.product_id)
                    .order("ds_categories.parentID, ds_product_categories.catID ASC")
                    .limit(1)
                    .pluck(:catID)
                    .first
  end

  def legacy_season
    @season ||= sku.season
  end
end
