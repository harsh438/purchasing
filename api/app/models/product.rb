class Product < ActiveRecord::Base
  self.table_name = :ds_products

  include LegacyMappings

  map_attributes id: :pID,
                 name: :pNum,
                 cost: :pCost,
                 price: :pPrice,
                 size: :pSize,
                 vendor_id: :venID,
                 on_sale: :pSale

  has_one :language_product, foreign_key: :pID
  has_many :language_product_options, foreign_key: :pID
  has_many :product_categories, foreign_key: :pID
  has_many :categories, through: :product_categories
  belongs_to :product_detail, foreign_key: :pID

  def as_json(*args)
    super.merge(id: id, name: name, price: price)
  end
end
