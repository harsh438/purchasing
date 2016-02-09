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
                 order_id: :OrderID,
                 legacy_attachments: :Attachments


  belongs_to :order, foreign_key: :OrderID

  has_many :goods_received_notice_events, foreign_key: :grn,
                                          after_add: :increment_totals,
                                          after_remove: :decrement_totals
  accepts_nested_attributes_for :goods_received_notice_events, allow_destroy: true

  has_many :vendors, through: :goods_received_notice_events

  has_many :purchase_orders, through: :goods_received_notice_events

  has_many :packing_lists
  accepts_nested_attributes_for :packing_lists

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

  def as_json_with_purchase_orders_and_packing_list_urls
    as_json_with_purchase_orders.tap do |grn|
      grn[:packing_list_urls] = packing_list_urls
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

  def packing_list_urls
    [].concat(packing_list_current_urls)
      .concat(packing_list_legacy_urls)
  end

  def packing_list_current_urls
    packing_lists.map(&:list).map { |list| list.expiring_url(300) }.reverse
  end

  def packing_list_legacy_urls
    return [] if !legacy_attachments
    attachement_list = []
    current_attachment = ''
    legacy_attachments.split(',').select do |attachment|
      current_attachment += attachment
      if attachment != '' and has_a_file_extension?(attachment)
        attachement_list.push(current_attachment)
        current_attachment = ''
      elsif current_attachment != ''
          current_attachment += ','
      end
    end

    attachement_list.map { |attachment| legacy_packing_list_url(attachment) }
  end

  private

  def legacy_packing_list_url(filename)
    "https://www.sdometools.com/tools/bookingin_tool/attachments/#{URI.escape(attachment)}"
  end

  def has_a_file_extension?(filename)
    /\.[a-z]{3,4}/.match(filename)
  end
end
