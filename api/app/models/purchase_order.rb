class PurchaseOrder < ActiveRecord::Base
  self.table_name = :po_summary
  self.primary_key = :po_num

  include LegacyMappings
  include Searchable

  map_attributes id: :po_num,
                 order_type: :orderType

  has_many :line_items, class_name: 'PurchaseOrderLineItem',
                        foreign_key: :po_number

  has_many :order_exports
  has_many :orders, through: :order_exports

  after_initialize :ensure_defaults
  after_initialize :set_legacy

  def po_number
    id
  end

  private

  def ensure_defaults
    self.po_date ||= Time.now
  end

  def set_legacy
    self.orderGrouping = ''
  end
end
