class PurchaseOrder < ActiveRecord::Base
  self.table_name = :po_summary
  self.primary_key = :po_num

  include LegacyMappings
  include Searchable
  include ActiveModel::Serialization

  map_attributes id: :po_num,
                 order_type: :orderType,
                 vendor_id: :venID,
                 vendor_name: :Brand

  has_many :line_items, class_name: 'PurchaseOrderLineItem',
                        foreign_key: :po_number

  has_many :order_exports
  has_many :orders, through: :order_exports

  belongs_to :vendor, foreign_key: :venID

  after_initialize :ensure_defaults
  after_initialize :set_legacy

  def self.from_yesterday
    where('po_date > ?', Date.yesterday)
  end

  def self.not_sent_in_peoplevox
    includes(:line_items).where(purchase_orders: { inPVX: 0 })
  end

  def self.includes_line_items
    includes(:line_items, line_items: [:vendor, :sku, :product, :purchase_order])
  end

  def po_number
    id
  end

  def quantity
    line_items.map(&:quantity).sum
  end

  def total
    line_items.map(&:total).sum
  end

  def as_json_with_line_items
    as_json.merge(purchase_order_line_items: line_items.as_json)
  end

  private

  def ensure_defaults
    self.po_date ||= Time.now
  end

  def set_legacy
    self.orderGrouping = ''
  end
end
