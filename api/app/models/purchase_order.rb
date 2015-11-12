class PurchaseOrder < ActiveRecord::Base
  self.table_name = :po_summary

  include LegacyMappings
  include Searchable

  map_attributes id: :po_num,
                 order_type: :orderType


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
