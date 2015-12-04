class Product < ActiveRecord::Base
  self.table_name = :ds_products

  include LegacyMappings

  map_attributes id: :pID,
                 name: :pNum,
                 price: :pPrice,
                 vendor_id: :venID,
                 on_sale: :pSale

  has_one :language_product, foreign_key: :pID
  belongs_to :product_detail, foreign_key: :pID

  def as_json(*args)
    super.merge(id: id, name: name, price: price)
  end
end
