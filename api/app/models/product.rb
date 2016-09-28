require 'set'

class Product < ActiveRecord::Base
  self.table_name = :ds_products

  UGLY_SHIPPING_CATEGORIES = [
    480, 462, 546, 784, 761, 780, 486, 635, 463, 596, 742
  ].freeze

  include LegacyMappings

  map_attributes id: :pID,
                 manufacturer_sku: :pNum,
                 cost: :pCost,
                 price: :pPrice,
                 sale_price: :pSalesPrice,
                 size: :pSize,
                 vendor_id: :venID,
                 on_sale: :pSale,
                 color: :pUDFValue2,
                 barcode: :pUDFValue1,
                 listing_genders: :pUDFValue3,
                 inv_track: :invTrack,
                 dropshipment: :pUDFValue5,
                 active: :pAvail,
                 photo_width: :pPhoto4Width

  has_one :reporting_category, foreign_key: :pid
  belongs_to :vendor, foreign_key: :venID
  has_many :language_products, foreign_key: :pID
  has_many :kit_managers, foreign_key: :pID
  has_many :product_images
  has_many :pvx_ins, foreign_key: :pid
  has_many :language_product_options, foreign_key: :pID
  has_many :product_categories, foreign_key: :pID
  has_many :categories, through: :product_categories
  has_many :skus
  has_many :latest_season_skus, -> {
    seasons_tbl = Season.arel_table
    seasons_alias = seasons_tbl.alias(:season_alias)
    skus_tbl = Sku.arel_table
    skus_alias = skus_tbl.alias(:skus_alias)
    query = seasons_tbl.project(seasons_alias[:SeasonID])
                       .from(seasons_alias)
                       .join(skus_alias)
                       .on(skus_alias[:season].eq(seasons_alias[:SeasonNickname]))
                       .where(skus_alias[:sku].eq(skus_tbl[:sku]))
                       .order(seasons_alias[:sort].desc)
                       .take(1)
    joins(:season).where(seasons_tbl[:SeasonID].eq(query).to_sql)
  }, class_name: 'Sku'
  has_many :genders, foreign_key: :pid, class_name: 'ProductGender'
  has_many :barcodes, through: :skus
  belongs_to :product_detail, foreign_key: :pID
  belongs_to :season, foreign_key: :pUDFValue4, primary_key: :SeasonNickname

  def related
    Product
      .joins(:language_products)
      .where({
        ds_language_products: { langID: 1 },
        ds_products: { pUDFValue3: listing_genders }
      })
      .where('ds_language_products.pName LIKE :name AND ds_products.pID != :id', {
        name: similar_product_name_search,
        id: id,
      })
      .where('ds_products.pPhoto4Width > 0 AND ds_products.pAvail = "Y"')
  end

  def color
    read_attribute(:pUDFValue2).scan(/\w+/)[0]
  end

  def as_json(*args)
    ProductSerializer.new(self).as_json(*args)
  end

  def lead_gender
    gender = Gender.new(ProductGender.find_by(pid: pID).gender)
    gender.reporting_name
  end

  def listing_gender_names
    listing_genders.split(/\W+/).each_with_object(Set.new) do |char, set|
      Gender.new(char).display_names.each { |g| set << g }
    end.to_a
  end

  def has_ugly_shipping_category?
    categories.where('ds_categories.catID IN (?)', UGLY_SHIPPING_CATEGORIES).exists?
  end

  def self.pending_import(last_imported_id, limit_count, last_import_timestamp)
    joins(skus: [:barcodes])
      .where('(ds_products.updated_at = :timestamp AND ds_products.pID > :id) OR (ds_products.updated_at > :timestamp)', {
        timestamp: last_import_timestamp,
        id: last_imported_id,
      })
      .group('ds_products.pID')
      .order('ds_products.updated_at ASC, ds_products.pID ASC')
      .limit(limit_count)
  end

  private

  def similar_product_name_search
    # Vendor Name - Product Name - Colour
    # becomes ...
    # Vendor Name - Product Name - %
    language_products.find_by(langID: 1)
      .name
        .split(' - ')
        .take(2)
        .join(' - ') + ' - %'
  end
end
