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
      legacy_supplier_sku: legacy_supplier_sku,
      legacy_video_url: legacy_video_url,
      legacy_reporting_category_name: cat_name,
      legacy_first_received_at: first_received_at,
      legacy_more_from_category: more_from_cat
    }
  end

  private

  attr_reader :sku

  def legacy_lead_gender
    @legacy_lead_gender ||= sku.gender
  end

  def legacy_reporting_category
    @legacy_reporting_category ||= sku.reporting_category.catid
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

  def legacy_video_url
    @url ||= sku.video_url
  end

  def cat_name
    @cat_name ||= sku.language_category.catName
  end

  def first_received_at
    @first_received_at ||= sku.first_received
  end

  def more_from_cat
    @more_from_cat ||= sku.ordered_catid
  end
end
