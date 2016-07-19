class Product < ActiveRecord::Base
  self.table_name = :ds_products

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
                 season: :pUDFValue4,
                 barcode: :pUDFValue1,
                 listing_genders: :pUDFValue3,
                 inv_track: :invTrack,
                 dropshipment: :pUDFValue5,
                 active: :pAvail

  has_one :reporting_category, foreign_key: :pid
  has_one :reporting_category, foreign_key: :pid
  has_one :vendor, foreign_key: :venID
  has_many :language_products, foreign_key: :pID
  has_many :kit_managers, foreign_key: :pID
  has_many :product_images
  has_many :pvx_ins, foreign_key: :pid
  has_many :language_product_options, foreign_key: :pID
  has_many :product_categories, foreign_key: :pid
  has_many :categories, through: :product_categories
  belongs_to :product_detail, foreign_key: :pID
  has_many :skus

  def as_json(*args)
    ProductSerializer.new(self).as_json(*args)
  end

  def master_sku
    skus.find_by(sku: id)
  end
end
