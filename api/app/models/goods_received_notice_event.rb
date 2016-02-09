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
                 vendor_id: :BrandID,
                 status: :Status,
                 delivery_date: :DeliveryDate,
                 booked_in_at: :BookedInDate

  belongs_to :goods_received_notice, foreign_key: :grn
  belongs_to :vendor, foreign_key: :BrandID

  belongs_to :purchase_order, foreign_key: :po

  after_initialize :ensure_defaults
  after_initialize :assign_vendor_from_purchase_order

  def received?; status == :received; end
  def delivered?; status == :delivered; end
  def late?; status == :late; end
  def booked?; status == :booked; end

  def status
    case send(:Status)
    when 2
      :delivered
    when 4
      :received
    when 7
      :late
    else
      :booked
    end
  end

  def as_json
    super.tap do |grn_event|
      grn_event['status'] = status
    end
  end

  def as_json_with_purchase_order
    as_json.tap do |grn_event|
      grn_event['purchase_order'] = purchase_order.as_json
    end
  end

  private

  def ensure_defaults
    self.status ||= 1
    self.pallets ||= 0
    self.units ||= 0
    self.cartons ||= 0
    self.booked_in_at ||= Time.now
  end

  def assign_vendor_from_purchase_order
    self.vendor_id = purchase_order.try(:vendor_id)
  end
end
