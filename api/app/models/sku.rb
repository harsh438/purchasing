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
  has_many :pvx_ins, through: :product
  has_many :product_images, through: :product
  has_one :reporting_category, through: :product
  has_many :product_categories, foreign_key: :pID
  has_many :categories, through: :product_categories
  accepts_nested_attributes_for :barcodes

  has_many :purchase_order_line_items

  validates_presence_of :manufacturer_sku

  def self.updated_since(timestamp, max_id)
    where('(skus.updated_at = ? and skus.id > ?) or (skus.updated_at > ?)', timestamp, max_id, timestamp)
  end

  def self.product_updated_since(timestamp, max_pid)
    where('(skus.updated_at = ? and skus.product_id > ?) or (skus.updated_at > ?)', timestamp, max_id, timestamp)
  end

  def self.with_barcode
    joins(:barcodes).where.not({ barcodes: { id: nil } })
  end

  def self.not_sent_in_peoplevox
    where({ sent_in_peoplevox: nil })
  end

  def sized?
    inv_track != 'P'
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

  def ordered_catid
    categories.order("ds_categories.parentID, ds_product_categories.catID ASC").pluck(:catID).first
  end

  def first_received
    pvx_ins.order("pvx_in.logged ASC").pluck(:logged).first
  end

  def master_sku
    Sku.find_by(sku: product_id)
  end
end
