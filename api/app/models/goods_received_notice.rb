class GoodsReceivedNotice < ActiveRecord::Base
  RECEIVED = 1

  self.table_name = :goods_received_number
  self.primary_key = :grn

  include BookingInConnection
  include LegacyMappings

  def self.not_archived
    eager_load(:goods_received_notice_events)
      .where('bookingin_events.id IS NOT NULL OR goods_received_number.BookedInDate >= DATE_SUB(NOW(), INTERVAL 1 DAY)')
      .uniq
  end

  def self.delivered_between(range)
    where(delivery_date: range)
  end

  def self.not_on_weekends
    where('DAYOFWEEK(goods_received_number.DeliveryDate) != 1 AND DAYOFWEEK(goods_received_number.DeliveryDate) != 7')
  end

  def self.with_purchase_order_id(purchase_order_id)
    eager_load(:goods_received_notice_events).where(bookingin_events: { po: purchase_order_id })
  end

  map_attributes id: :grn,
                 units: :TotalUnits,
                 cartons: :CartonsExpected,
                 pallets: :PaletsExpected,
                 delivery_date: :DeliveryDate,
                 original_delivery_date: :LastDeliveryDate,
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
                 order_id: :OrderID,
                 legacy_attachments: :Attachments,
                 user_id: :UserID

  belongs_to :order, foreign_key: :OrderID
  belongs_to :user, foreign_key: :UserID

  has_many :goods_received_notice_events, foreign_key: :grn,
                                          after_add: [:increment_totals,
                                                      :set_delivery_date_on_event,
                                                      :set_user_id],
                                          after_remove: :decrement_totals,
                                          dependent: :destroy

  accepts_nested_attributes_for :goods_received_notice_events, allow_destroy: true

  has_many :vendors, through: :goods_received_notice_events

  has_many :purchase_orders, through: :goods_received_notice_events

  has_many :packing_lists
  has_one :packing_condition, foreign_key: :grn
  accepts_nested_attributes_for :packing_lists, :packing_condition

  after_initialize :ensure_defaults
  after_initialize :ensure_packing_condition
  after_update :set_delivery_date_on_all_events

  def delivered?
    status == :delivered
  end

  def received?
    status == :received
  end

  def late?
    delivery_date < Date.today
  end

  def update_received_status_and_totals
    self.units_received = goods_received_notice_events.sum(:units)
    self.cartons_received = goods_received_notice_events.sum(:cartons_received)

    if received?
      self.received = RECEIVED
      self.received_at = Time.current
    end

    save!
  end

  def status
    if goods_received_notice_events.any?(&:late?)
      :late
    elsif goods_received_notice_events.any?(&:booked?)
      :booked
    elsif goods_received_notice_events.any?(&:delivered?)
      :delivered
    elsif goods_received_notice_events.any? and goods_received_notice_events.all?(&:received?)
      :received
    else
      :booked
    end
  end

  def vendor_name
    vendors.map(&:name).join(', ')
  end

  def as_json(options = {})
    super.tap do |grn|
      grn[:delivered] = delivered? ? 1 : 0
      grn[:delivery_date] = grn['delivery_date'].to_s
      grn[:status] = status
      grn[:vendor_name] = vendor_name
      grn[:user_name] = user.try(:name)
    end
  end

  def as_json_with_purchase_orders
    as_json.tap do |grn|
      grn[:goods_received_notice_events] = goods_received_notice_events.map(&:as_json_with_purchase_order)
    end
  end

  def as_json_with_purchase_orders_and_packing_list_urls
    as_json_with_purchase_orders.tap do |grn|
      grn[:packing_list_urls] = packing_list_attachments.urls
      grn[:packing_condition] = packing_condition || ensure_packing_condition
    end
  end

  def delete_packing_list_by_url!(url)
    packing_list_attachments.delete_by_url(url)
  end

  private

  def ensure_defaults
    self.received ||= 0
    self.checking ||= 0
    self.checked ||= 0
    self.processing ||= 0
    self.processed ||= 0
    self.booked_in_at ||= Time.current
    self.original_delivery_date ||= delivery_date
    self.received_at ||= 0
    self.page_count ||= 0
    self.order_id ||= 0
    self.cartons_received ||= 0
    self.units ||= 0
    self.cartons ||= 0
    self.pallets ||= 0
    self.legacy_attachments ||= ''
  end

  def ensure_packing_condition
    self.packing_condition || build_packing_condition
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

  def set_delivery_date_on_event(grn_event)
    grn_event.update!(delivery_date: delivery_date)
  end

  def set_delivery_date_on_all_events
    if delivery_date_changed?
      goods_received_notice_events.update_all(DeliveryDate: delivery_date)
    end
  end

  def set_user_id(grn_event)
    self.user_id ||= grn_event.user_id
    save!
  end

  def packing_list_attachments
    PackingListAttachments.new(self)
  end
end
