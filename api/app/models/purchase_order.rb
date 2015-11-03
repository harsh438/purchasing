class PurchaseOrder < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include LegacyMappings
  include Searchable

  CSV_COLUMN_ORDER = %w(po_number
                        status
                        product_id
                        product_name
                        product_sku
                        product_cost
                        product_size
                        order_id
                        order_date
                        order_type
                        ordered_units
                        ordered_cost
                        ordered_value
                        delivery_date
                        delivered_units
                        delivered_cost
                        delivered_value
                        cancelled_units
                        cancelled_cost
                        cancelled_value
                        operator
                        closing_date
                        weeks_on_sale
                        brand_size
                        gender
                        comment)

  def self.to_csv
    CSV.generate do |csv|
      csv << CSV_COLUMN_ORDER.map(&:humanize)

      where(nil).each do |purchase_order|
        csv << purchase_order.as_json({}).values_at(*CSV_COLUMN_ORDER.map(&:to_sym))
      end
    end
  end

  belongs_to :vendor, foreign_key: :orderTool_venID
  belongs_to :product, foreign_key: :pID
  belongs_to :summary, foreign_key: :po_number

  has_many :suppliers, through: :vendor, class_name: 'Supplier'
  map_attributes id: :id,
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
                 summary_id: :po_number,
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
                 product_barcode: :orderTool_barcode,
                 sell_price: :orderTool_sellPrice,
                 brand_size: :orderTool_brandSize,
                 supplier_list_price: :orderTool_SupplierListPrice,
                 rrp: :orderTool_RRP,

                 # Unused but necessary for insertion
                 reporting_product_id: :reporting_pID,
                 original_product_id: :original_pID,
                 original_option_id: :original_oID

  filters :vendor_id,
          :gender,
          :summary_id,
          :season,
          :product_sku,
          :category_id,
          :product_id,
          :operator

  paginates_per 50

  scope :with_summary, -> { where.not(summary_id: '') }
  scope :with_valid_status, -> { where('status in (-1,2,3,4,5)') }

  def self.filter_supplier(context)
    joins(vendor: :supplier_vendors)
      .where(suppliers_to_brands: { SupplierID: context[:supplier] })
  end

  def self.filter_status(context)
    values = [context[:status]].flatten
    values = Status.ints_from_filter_syms(values.map(&:to_sym))
    where(status: values)
  end

  def self.filter_order_type(context)
    joins(:summary).where(po_summary: { orderType: context[:order_type] })
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
      where('(drop_date < ? or (cancelled_date < ?)', context[:date_until], context[:date_until])
    else
      where('(drop_date < ?)', context[:date_until])
    end
  end

  def self.order_types
    PurchaseOrder.joins(:summary)
                 .pluck(:orderType)
                 .uniq
                 .map do |c|
                   name = OrderType.string_from(c)
                   { id: c, name: name } if name
                 end.compact

  end

  def self.seasons
    PurchaseOrder.pluck('distinct po_season')
                 .map do |season|
                   { id: season, name: season } if season.present?
                 end
                 .compact
  end

  def self.genders
    PurchaseOrder.pluck('distinct orderTool_LG')
                 .map do |c|
                   name = Gender.string_from(c)
                   { id: c, name: name } if name
                 end
                 .compact
  end

  def orderTool_LG
    Gender.string_from(super)
  end

  def category
    return Category.english.where(category_id: category_id)
  end

  def product_price
    try(:product).try(:price) || 0
  end

  def closing_date
    try(:product).try(:product_detail).try(:closing_date) || 0
  end

  def weeks_on_sale
    try(:product).try(:product_detail).try(:planned_weeks_on_sale) || 0
  end

  def status
    Status.sym_from_int(super)
  end

  def ordered_cost
    quantity * cost
  end

  def ordered_value
    quantity * product_price
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
    end
  end

  def cancelled_cost
    if cancelled?
      cancelled_quantity * cost
    end
  end

  def cancelled_value
    if cancelled?
      cancelled_quantity * product_price
    end
  end

  def balance_quantity
    quantity - delivered_quantity
  end

  def balance_cost
    ordered_cost - delivered_cost
  end

  def balance_value
    ordered_value - delivered_value
  end

  def order_type
    t = try(:summary).try(:order_type)
    return '' unless t.present?
    OrderType.string_from(t)
  end

  def as_json(*args)
    super.merge(order_type: order_type,
                ordered_cost: monetize(ordered_cost),
                ordered_value: monetize(ordered_value),
                delivered_quantity: delivered_quantity,
                delivered_cost: monetize(delivered_cost),
                delivered_value: monetize(delivered_value),
                cancelled_quantity: cancelled_quantity,
                cancelled_cost: monetize(cancelled_cost),
                cancelled_value: monetize(cancelled_value),
                balance_quantity: balance_quantity,
                balance_cost: monetize(balance_cost),
                balance_value: monetize(balance_value),
                closing_date: closing_date)
  end

  private

  def monetize(figure)
    number_to_currency(figure, unit: '£')
  end
end
