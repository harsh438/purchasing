class PurchaseOrderLineItem < ActiveRecord::Base
  self.table_name = 'purchase_orders'

  include ActionView::Helpers::NumberHelper
  include LegacyMappings
  include Searchable

  def self.filter_supplier(context)
    joins(vendor: :supplier_vendors)
      .where(suppliers_to_brands: { SupplierID: context[:supplier] })
  end

  def self.filter_product_sku(context)
    where('orderTool_SKU LIKE ?', "%#{context[:product_sku]}%")
  end

  def self.filter_status(context)
    values = [context[:status]].flatten
    values = Status.ints_from_filter_syms(values.map(&:to_sym))

    if context[:status].include?('balance')
      filtered_values = values - [4]
      where('(purchase_orders.status IN (?)) OR
             (purchase_orders.status=4 AND (purchase_orders.qty +
                                            purchase_orders.qtyAdded -
                                            purchase_orders.qtyDone) = 0)', filtered_values)
    else
      where(status: values)
    end
  end

  def self.filter_order_type(context)
    joins(:purchase_order).where(po_summary: { orderType: context[:order_type] })
  end

  def self.filter_date_from(context)
    if context[:status] == ['cancelled']
      where('cancelled_date > ?', context[:date_from])
    elsif context[:status] and context[:status].include?('cancelled')
      where('(drop_date > ? or (cancelled_date > ?))', context[:date_from], context[:date_from])
    else
      where('(drop_date > ?)', context[:date_from])
    end
  end

  def self.filter_date_until(context)
    if context[:status] == ['cancelled']
      where('cancelled_date < ?', context[:date_from])
    elsif context[:status] and context[:status].include?('cancelled')
      where('(drop_date < ? or (cancelled_date < ?))', context[:date_until], context[:date_until])
    else
      where('(drop_date < ?)', context[:date_until])
    end
  end

  def self.order_types
    PurchaseOrderLineItem.joins(:purchase_order)
      .pluck(:orderType)
      .uniq
      .map do |c|
        name = OrderType.string_from(c)
        { id: c, name: name.split(/(\W)/).map(&:capitalize).join } if name
      end
      .compact
  end

  def self.seasons
    PurchaseOrderLineItem.pluck('distinct po_season')
                         .map do |season|
                           { id: season, name: season } if season.present?
                         end
                         .compact
  end

  def self.genders
    PurchaseOrderLineItem.pluck('distinct orderTool_LG')
                         .map do |c|
                           name = Gender.string_from(c)
                           { id: c, name: name } if name
                         end
                         .compact
  end

  scope :with_summary, -> { where.not(po_number: '').where.not(po_number: 0) }
  scope :with_valid_status, -> { where('purchase_orders.status in (-1,2,3,4,5)') }

  belongs_to :vendor, foreign_key: :orderTool_venID
  belongs_to :product, foreign_key: :pID
  belongs_to :purchase_order, foreign_key: :po_number

  has_many :suppliers, through: :vendor

  after_initialize :set_legacy_fields
  after_initialize :ensure_defaults

  map_attributes id: :id,
                 po_number: :po_number,
                 product_id: :pID,
                 option_id: :oID,
                 quantity: :qty,
                 quantity_added: :qtyAdded,
                 quantity_done: :qtyDone,
                 status: :status,
                 created_at: :added,
                 order_date: :order_date,
                 delivery_date: :drop_date,
                 arrived_date: :arrived_date,
                 invoice_payable_date: :inv_date,
                 operator: :operator,
                 comment: :comment,
                 cost: :cost,
                 cancelled_date: :cancelled_date,
                 in_pvx: :inPVX,
                 season: :po_season,
                 category_id: :orderTool_RC,
                 gender: :orderTool_LG,
                 vendor_id: :orderTool_venID,
                 line_id: :orderToolItemID,
                 product_name: :orderTool_productName,
                 product_sku: :orderTool_SKU,
                 product_size: :orderTool_SDsize,
                 barcode: :orderTool_barcode,
                 sell_price: :orderTool_sellPrice,
                 manufacturer_size: :orderTool_brandSize,
                 supplier_list_price: :orderTool_SupplierListPrice,
                 product_rrp: :orderTool_RRP,
                 reporting_pid: :reporting_pID,
                 original_pid: :original_pID,
                 original_option_id: :original_oID,
                 single_line_id: :orderTool_SingleLineID,
                 item_id: :orderToolItemID

  filters :vendor_id,
          :gender,
          :po_number,
          :season,
          :category_id,
          :product_id,
          :operator

  paginates_per 200

  def brand
    vendor.try(:name)
  end

  def category
    LanguageCategory.english.find_by(category_id: category_id).try(:name)
  end

  def closing_date
    try(:product).try(:product_detail).try(:closing_date)
  end

  def weeks_on_sale
    try(:product).try(:product_detail).try(:planned_weeks_on_sale) || 0
  end

  def status
    Status.sym_from_int(super)
  end

  def product_price
    product.try(:price) || 0
  end

  def product_cost
    cost
  end

  def supplier_style_code
    product.try(:product_detail).try(:supplier_style_code)
  end
  alias_method :brand_style_code, :supplier_style_code

  def supplier_color_code
    product.try(:product_detail).try(:supplier_color_code)
  end
  alias_method :brand_color_code, :supplier_color_code

  def supplier_product_name
    product.try(:product_detail).try(:supplier_product_name)
  end
  alias_method :brand_product_name, :supplier_product_name

  def supplier_color_name
    product.try(:product_detail).try(:supplier_color_name)
  end
  alias_method :brand_color_name, :supplier_color_name

  def item_code
    product_sku
  end

  def brand_size
    manufacturer_size
  end

  def order_first_received
    invoice_payable_date
  end

  def ordered_quantity
    quantity
  end

  def ordered_cost
    ordered_quantity * cost
  end
  alias_method :total, :ordered_cost

  def ordered_value
    ordered_quantity * product_price
  end

  def delivered_quantity
    quantity_done + quantity_added
  end

  def delivered_cost
    delivered_quantity * cost
  end

  def delivered_value
    delivered_quantity * product_price
  end

  def cancelled?
    status == :cancelled
  end

  def cancelled_quantity
    if cancelled?
      quantity - delivered_quantity
    else
      0
    end
  end

  def cancelled_cost
    if cancelled?
      cancelled_quantity * cost
    else
      0
    end
  end

  def cancelled_value
    if cancelled?
      cancelled_quantity * product_price
    else
      0
    end
  end

  def balance_quantity
    quantity - delivered_quantity - cancelled_quantity
  end

  def balance_cost
    ordered_cost - delivered_cost - cancelled_cost
  end

  def balance_value
    ordered_value - delivered_value - cancelled_value
  end

  def order_type
    order_type = purchase_order.try(:order_type)
    return '' unless order_type.present?
    OrderType.string_from(order_type).split(/(\W)/).map(&:capitalize).join
  end

  def internal_sku
    return if option_id == 0

    "#{pID}-#{Element.id_from_option(pID, option_id)}"
  end

  def as_json(options = {})
    options[:unit] ||= '£'

    super.merge(product_json(options))
         .merge(quantity_cost_and_value_json(options))
         .merge(order_id: id,
                order_type: order_type,
                order_first_received: order_first_received,
                weeks_on_sale: weeks_on_sale,
                closing_date: closing_date)
  end

  def cancel
    unless cancelled?
      update!(cancelled_date: Date.today, status: -1)
    end

    self
  end

  def uncancel
    if cancelled?
      update_columns(cancelled_date: '0000-00-00', status: 2)
    end

    self
  end

  private

  def ensure_defaults
    self.added ||= Time.now
    self.arrived_date ||= 0
    self.cancelled_date ||= 0
    self.inv_date ||= 0
  end

  def set_legacy_fields
    self.reporting_pid ||= 0
    self.original_pid ||= 0
    self.original_option_id ||= 0
    self.line_id ||= 0
  end

  def product_json(options)
    { internal_sku: internal_sku,
      product_cost: number_to_currency(product_cost, options),
      product_size: product_size,
      product_rrp: number_to_currency(product_rrp, options),
      category: category,
      brand: brand,
      supplier_style_code: supplier_style_code,
      supplier_color_code: supplier_color_code,
      supplier_product_name: supplier_product_name,
      supplier_color_name: supplier_color_name,
      brand_style_code: brand_style_code,
      brand_color_code: brand_color_code,
      brand_product_name: brand_product_name,
      brand_color_name: brand_color_name,
      brand_size: brand_size,
      item_code: item_code }
  end

  def quantity_cost_and_value_json(options)
    { ordered_quantity: ordered_quantity,
      ordered_cost: number_to_currency(ordered_cost, options),
      ordered_value: number_to_currency(ordered_value, options),
      total: ordered_cost,
      delivery_date: delivery_date.to_s,
      delivered_quantity: delivered_quantity,
      delivered_cost: number_to_currency(delivered_cost, options),
      delivered_value: number_to_currency(delivered_value, options),
      cancelled_quantity: cancelled_quantity,
      cancelled_cost: number_to_currency(cancelled_cost, options),
      cancelled_value: number_to_currency(cancelled_value, options),
      balance_quantity: balance_quantity,
      balance_cost: number_to_currency(balance_cost, options),
      balance_value: number_to_currency(balance_value, options) }
  end
end
