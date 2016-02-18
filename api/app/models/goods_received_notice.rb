class GoodsReceivedNotice < ActiveRecord::Base
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
  accepts_nested_attributes_for :packing_lists

  after_initialize :ensure_defaults

  def delete_packing_list_by_url!(url)
    return nil unless is_packing_list_url?(url)
    if is_packing_list_legacy_url?(url)
      delete_legacy_packing_list_by_url!(url)
    else
      delete_current_packing_list_by_url!(url)
    end
  end

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
    vendors.map(&:name).join(', ')
  end

  def as_json(options = {})
    super.tap do |grn|
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
      grn[:packing_list_urls] = packing_list_urls
    end
  end

  private

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

  def is_packing_list_legacy_url?(url)
    packing_list_legacy_urls.include?(url)
  end

  def is_packing_list_current_url?(url)
    filename = packing_list_filename_from_url(url)
    !!packing_lists.find_by(:list_file_name => filename)
  end

  def is_packing_list_url?(url)
    is_packing_list_legacy_url?(url) || is_packing_list_current_url?(url)
  end

  def packing_list_filename_from_url(url)
    slash_index = url.rindex('/')
    return nil unless slash_index
    encoded_filename = url[slash_index + 1..-1]
    return nil unless encoded_filename
    parameter_index = encoded_filename.index('?')
    if parameter_index
      encoded_filename = encoded_filename[0..parameter_index - 1]
    end
    URI.decode(encoded_filename)
  end

  def packing_list_urls
    [].concat(packing_list_current_urls)
      .concat(packing_list_legacy_urls)
  end

  def packing_list_current_urls
    packing_lists.map(&:list_url).reverse
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

  def delete_current_packing_list_by_url!(url)
    filename = packing_list_filename_from_url(url)
    packing_list = packing_lists.find_by(:list_file_name => filename)
    return nil unless packing_list
    packing_list.destroy!
  end

  def delete_legacy_packing_list_by_url!(url)
    filename = packing_list_filename_from_url(url)
    legacy_attachments.sub!(",#{filename}", '').sub(filename, ',')
    save!
  end

  def ensure_defaults
    self.received ||= 0
    self.checking ||= 0
    self.checked ||= 0
    self.processing ||= 0
    self.processed ||= 0
    self.booked_in_at ||= Time.now
    self.original_delivery_date ||= delivery_date
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

  def set_delivery_date_on_event(grn_event)
    grn_event.update!(delivery_date: delivery_date)
  end

  def set_user_id(grn_event)
    self.user_id ||= grn_event.user_id
    save!
  end

  private

  def legacy_packing_list_url(filename)
    "https://www.sdometools.com/tools/bookingin_tool/attachments/#{URI.escape(filename)}"
  end

  def has_a_file_extension?(filename)
    /\.[a-z]{3,4}/.match(filename)
  end
end
