class GoodsReceivedNoticeEvent < ActiveRecord::Base
  self.table_name = :bookingin_events
  self.primary_key = :ID

  include BookingInConnection
  include LegacyMappings

  map_attributes id: :ID,
                 purchase_order_id: :po,
                 units: :TotalUnits,
                 cartons: :CartonsExpected,
                 pallets: :PaletsExpected,
                 vendor_id: :BrandID

  belongs_to :goods_received_notice, foreign_key: :grn
  belongs_to :vendor, foreign_key: :BrandID

  belongs_to :purchase_order, foreign_key: :po

  after_initialize :assign_vendor_from_purchase_order

  private

  def assign_vendor_from_purchase_order
    self.vendor_id = purchase_order.try(:vendor_id)
  end
end
