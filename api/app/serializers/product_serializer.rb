class ProductSerializer < ActiveModel::Serializer
  INV_TRACKS = {
    'O' => 'sized',
    'P' => 'unsized'
  }.freeze

  attributes :id, :sku, :price, :cost_price, :sale_price,
             :active, :barcode, :brand, :properties,
             :dropshipment, :use_legacy_slug, :images,
             :legacy_lead_gender, :legacy_reporting_category,
             :legacy_season, :legacy_supplier_sku,
             :legacy_reporting_category_name, :legacy_first_received_at,
             :legacy_more_from_category, :parts, :children,
             :contents, :options, :shipping_category, :related, :inv_track, :classification

  private

  def related
    also_bought + other_color
  end

  def other_color
    object.other_color_related.map.with_index do |sku, i|
      {
        sort_in_type: i + 1,
        product_id: sku.product_id,
        type: 'other_colors'
      }
    end
  end

  def also_bought
    object.also_bought_related.map.with_index do |product, i|
      {
        sort_in_type: i + 1,
        product_id: product.id,
        type: 'also_bought',
      }
    end
  end

  def shipping_category
    object.has_ugly_shipping_category? ? 'Ugly' : 'Default'
  end

  def brand
    object.vendor.try(:id)
  end

  def use_legacy_slug
    true
  end

  def sku
    object.id
  end

  def cost_price
    object.cost
  end

  def properties
    {
      'Gender' => object.listing_gender_names.join(','),
      'Colour' => object.color,
      'Product Type' => object.sku_product_type
    }
  end

  def dropshipment
    object.dropshipment == 'D-R-P'
  end

  def barcode
    object.barcodes.latest.first.try(:barcode)
  end

  def images
    object.product_images.map(&:as_json)
  end

  def legacy_lead_gender
    object.lead_gender
  end

  def legacy_reporting_category
    object.reporting_category.try(:category).try(:id)
  end

  def legacy_season
    object.season.try(:nickname)
  end

  def legacy_supplier_sku
    object.manufacturer_sku
  end

  def legacy_reporting_category_name
    object.reporting_category.category.language_categories.first.name
  end

  def legacy_first_received_at
    object.pvx_ins.first.try(:logged)
  end

  def legacy_more_from_category
    object.categories.first.try(:id)
  end

  def parts
    object.kit_managers.map(&:item_code)
  end

  def children
    Sku::Deduplicator.new.without_duplicates(*sized_latest_season_skus)
  end

  def contents
    object.language_products.map do |language_product|
      ContentSerializer.new(language_product).as_json
    end
  end

  def options
    sized? ? ['Size'] : []
  end

  def sized?
    sized_latest_season_skus.any?
  end

  def sized_latest_season_skus
    @skus ||= object.latest_season_skus.with_barcode.to_a.select(&:sized?)
  end

  def classification
    {
      brand_product_name: object.model_name
    }
  end
  def inv_track
    INV_TRACKS.fetch(object.inv_track)
  end
end
