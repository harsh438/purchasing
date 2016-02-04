class GoodsReceivedNotice < ActiveRecord::Base
  self.table_name = :goods_received_number
  self.primary_key = :grn

  include BookingInConnection
  include LegacyMappings

  def self.delivered_between(range)
    where(delivery_date: range)
  end

  def self.not_on_weekends
    where('DAYOFWEEK(DeliveryDate) != 1 AND DAYOFWEEK(DeliveryDate) != 7')
  end

  map_attributes id: :grn,
                 units: :TotalUnits,
                 cartons: :CartonsExpected,
                 pallets: :PaletsExpected,
                 delivery_date: :DeliveryDate,
                 received: :isReceived,
                 checking: :isChecking,
                 checked: :isChecked,
                 processing: :isProcessing,
                 processed: :isProcessed,
                 received_at: :DateReceived,
                 page_count: :NoOfPages,
                 units_received: :UnitsReceived,
                 cartons_received: :CartonsReceived,
                 booked_in_at: :BookedInDate,
                 order_id: :OrderID

  belongs_to :order, foreign_key: :OrderID

  has_many :goods_received_notice_events, foreign_key: :grn,
                                          after_add: :increment_totals,
                                          after_remove: :decrement_totals
  accepts_nested_attributes_for :goods_received_notice_events, allow_destroy: true

  has_many :vendors, through: :goods_received_notice_events

  has_many :purchase_orders, through: :goods_received_notice_events

  after_initialize :ensure_defaults

  # def received_at
  #   date = super

  #   unless date.to_s === '00/00/0000' or date.to_s === '01/01/0001'
  #     date
  #   end
  # end

  def late?
    delivery_date < Date.today
  end

  def status
    if processed?
      :received
    elsif processing?
      :received
    elsif checked?
      :received
    elsif checking?
      :received
    elsif received?
      :delivered
    elsif late?
      :late
    else
      :balance
    end
  end

  def vendor_name
    vendors.first.try(:name)
  end

  def as_json(options = {})
    super.tap do |grn|
      grn[:delivery_date] = grn['delivery_date'].to_s
      grn[:status] = status
      grn[:vendor_name] = vendor_name
    end
  end

  def as_json_with_purchase_orders
    as_json.tap do |grn|
      grn[:goods_received_notice_events] = goods_received_notice_events.map(&:as_json_with_purchase_order)
    end
  end

  private

  def ensure_defaults
    self.received ||= 0
    self.checking ||= 0
    self.checked ||= 0
    self.processing ||= 0
    self.processed ||= 0
    self.booked_in_at ||= Time.now
    self.received_at ||= 0
    self.page_count ||= 0
    self.order_id ||= 0
    self.cartons_received ||= 0
    self.units ||= 0
    self.cartons ||= 0
    self.pallets ||= 0
  end

  def increment_totals(grn_event)
    self.units += grn_event.units
    self.cartons += grn_event.cartons
    self.pallets += grn_event.pallets
    save!
  end

  def decrement_totals(grn_event)
    self.units -= grn_event.units
    self.cartons -= grn_event.cartons
    self.pallets -= grn_event.pallets
    save!
  end
end
