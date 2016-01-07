class Sku < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

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

  def has_barcode?(barcode)
    barcodes.pluck(:barcode).include?(barcode)
  end

  def as_json(options = {})
    super.tap do |sku|
      sku['created_at'] = sku['created_at'].to_s
      sku['updated_at'] = sku['updated_at'].to_s
      sku['cost_price'] = number_to_currency(sku['cost_price'], unit: '£')
      sku['price'] = number_to_currency(sku['price'], unit: '£')
    end
  end

  def as_json_with_vendor_category_and_barcodes
    as_json.merge(category_name: language_category.try(:name),
                  vendor_name: vendor.try(:name),
                  barcodes: barcodes.map(&:as_json))
  end
end
