class Sku < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  def self.nonexistant_skus(all_skus)
    existing_skus = Sku.where(sku: all_skus).pluck(:sku)
    all_skus - existing_skus
  end

  def self.nonexistant_skus_with_season(all_skus, season)
    existing_skus = Sku.where(sku: all_skus, season: season).pluck(:sku)
    all_skus - existing_skus
  end

  scope :latest, -> { order(updated_at: :desc) }

  paginates_per 50

  belongs_to :product, touch: true
  belongs_to :vendor
  belongs_to :element, foreign_key: :element_id
  belongs_to :language_product, foreign_key: :language_product_id
  belongs_to :language_category, foreign_key: :category_id
  belongs_to :option, foreign_key: :option_id
  belongs_to :language_product_option, foreign_key: :language_product_option_id
  belongs_to :season, foreign_key: :season, primary_key: :SeasonNickname

  has_many :barcodes
  has_many :pvx_ins, through: :product
  has_many :product_images, through: :product
  has_many :product_categories, foreign_key: :pID
  has_many :categories, through: :product_categories
  has_many :purchase_order_line_items

  has_one :reporting_category, through: :product

  accepts_nested_attributes_for :barcodes

  validates_presence_of :manufacturer_sku
  validate :sku_size

  def self.updated_since(timestamp, max_id)
    where('(skus.updated_at = ? and skus.id > ?) or (skus.updated_at > ?)', timestamp, max_id, timestamp)
  end

  def self.product_updated_since(timestamp, max_pid)
    where('(skus.updated_at = ? and skus.product_id > ?) or (skus.updated_at > ?)', timestamp, max_id, timestamp)
  end

  def self.with_barcode
    joins(:barcodes).group('skus.sku, skus.season, barcodes.barcode')
  end

  def self.not_sent_in_peoplevox
    where({ sent_in_peoplevox: nil })
  end

  def self.other_colors(partial_man_sku, current_pid)
    where('skus.manufacturer_sku LIKE ? AND product_id IS NOT NULL AND product_id != ?',
      "#{partial_man_sku}-%", current_pid
    ).group(:product_id)
  end

  def sized?
    inv_track == 'O' && !!(element && option && language_product_option)
  end

  def should_be_sized?
    inv_track == 'O'
  end

  def as_json(options = {})
    super.tap do |sku|
      sku['created_at'] = sku['created_at'].to_s
      sku['updated_at'] = sku['updated_at'].to_s
      sku['list_price'] = number_to_currency(sku['list_price'], unit: '£')
      sku['cost_price'] = number_to_currency(sku['cost_price'], unit: '£')
      sku['price'] = number_to_currency(sku['price'], unit: '£')
    end
  end

  def as_json_with_vendor_category_and_barcodes
    as_json.merge(category_name: language_category.try(:name),
                  vendor_name: vendor.try(:name),
                  barcodes: barcodes.map(&:as_json))
  end

  def self.po_by_operator(ot_number)
    Sku.joins(:purchase_order_line_items).where('purchase_orders.operator =?', "OT_#{ot_number}")
  end

  def sku_size
    sizes = Sku.where(sku: sku).pluck(:size)
    return true if sizes.include?(size) and sizes.uniq.length == 1
    return true if sizes.empty?
    errors.add(:size, 'Invalid size for sku')
  end

  def self.by_season(sku, season)
    where(sku: sku, season: season)
  end
end
