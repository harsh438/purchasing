class Sku < ActiveRecord::Base
  scope :latest, -> { order(created_at: :desc) }

  paginates_per 50

  belongs_to :product
  belongs_to :vendor
  belongs_to :element
  belongs_to :language_product, foreign_key: :language_product_id
  belongs_to :language_category, foreign_key: :category_id
  belongs_to :option, foreign_key: :option_id
  belongs_to :language_product_option, foreign_key: :language_product_option_id

  has_many :barcodes
  accepts_nested_attributes_for :barcodes

  validates :sku, uniqueness: true
  validates_presence_of :manufacturer_sku
end
