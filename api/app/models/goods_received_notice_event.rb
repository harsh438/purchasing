class GoodsReceivedNoticeEvent < ActiveRecord::Base
  self.table_name = :bookingin_events
  self.primary_key = :ID

  include BookingInConnection
  include LegacyMappings

  def self.not_on_weekends
    where('DAYOFWEEK(bookingin_events.DeliveryDate) != 1 AND DAYOFWEEK(bookingin_events.DeliveryDate) != 7')
  end

  map_attributes id: :ID,
                 purchase_order_id: :po,
                 units: :TotalUnits,
                 cartons: :CartonsExpected,
                 pallets: :PaletsExpected,
                 vendor_id: :BrandID,
                 status: :Status,
                 delivery_date: :DeliveryDate,
                 booked_in_at: :BookedInDate,
                 user_id: :UserID,
                 received: :IsReceived,
                 received_at: :DateReceived

  belongs_to :goods_received_notice, foreign_key: :grn
  belongs_to :vendor, foreign_key: :BrandID
  belongs_to :purchase_order, foreign_key: :po, touch: true
  belongs_to :user, foreign_key: :UserID

  after_initialize :ensure_defaults
  after_initialize :assign_vendor_from_purchase_order
  after_save :mark_grn_as_received

  def delivered?; human_status == :delivered; end
  def received?; human_status == :received; end
  def late?; human_status == :late; end
  def booked?; human_status == :booked; end

  def received=(received)
    write_attribute(:IsReceived, received)
    self.status = 4
    self.received_at = Time.current
  end

  def mark_grn_as_received
    if received_changed? and received?
      goods_received_notice.receive_event(self)
    end
  end

  def human_status
    case send(:Status)
    when 2
      :delivered
    when 4
      :received
    else
      if delivery_date.try(:past?)
        :late
      else
        :booked
      end
    end
  end

  def as_json
    super.tap do |grn_event|
      grn_event['delivery_date'] = delivery_date.to_s
      grn_event['status'] = human_status
      grn_event['vendor_name'] = vendor.try(:name)
      grn_event['user_name'] = user.try(:name)
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
    self.booked_in_at ||= Time.current
  end

  def assign_vendor_from_purchase_order
    self.vendor_id = purchase_order.try(:vendor_id)
  end
end
