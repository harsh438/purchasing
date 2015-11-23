class Sku < ActiveRecord::Base
  paginates_per 50

  belongs_to :product
  belongs_to :element
  belongs_to :product_option, foreign_key: :option_id

  validates_presence_of :manufacturer_sku
end
