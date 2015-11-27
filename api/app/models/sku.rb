class Sku < ActiveRecord::Base
  paginates_per 50

  belongs_to :product
  belongs_to :element
  belongs_to :language_product, foreign_key: :language_product_id
  belongs_to :language_category, foreign_key: :category_id
  belongs_to :language_product_option, foreign_key: :option_id

  validates_presence_of :manufacturer_sku
end
