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
  has_many :latest_season_skus, -> (prod) {
    joins(:season)
      .where('seasons.SeasonId = (
        SELECT a.SeasonId
        FROM seasons AS a
        INNER JOIN skus AS b ON b.season = a.SeasonNickname
        WHERE b.product_id = ?
        ORDER BY a.sort DESC
        LIMIT 1
      )', prod.id)
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

  def as_json(*args)
    ProductSerializer.new(self).as_json(*args)
  end

  def lead_gender
    listing_genders.split(/\W+/).reduce(Set.new) do |set, gender_key|
      char = Gender.string_from(gender_key.upcase)
      char.nil? ? set : set << char
    end.to_a
  end

  def has_ugly_shipping_category?
    categories.where('ds_categories.catID IN (?)', UGLY_SHIPPING_CATEGORIES).exists?
  end

  def self.pending_import(last_imported_id, limit_count, last_import_timestamp)
    joins(skus: [:barcodes])
      .where('(skus.updated_at = :timestamp AND ds_products.pID > :id) OR (skus.updated_at > :timestamp)', {
        timestamp: last_import_timestamp,
        id: last_imported_id,
      })
      .group('ds_products.pID')
      .order('skus.updated_at ASC, ds_products.pID ASC')
      .limit(limit_count)
  end

  def updated_at
    skus.joins(:barcodes)
      .order(updated_at: 'DESC')
      .first
      .try(:updated_at)
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
