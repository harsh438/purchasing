class PurchaseOrder < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include LegacyMappings
  include Searchable

  CSV_COLUMN_ORDER = %w(product_barcode
                        po_number
                        order_type
                        product_id
                        product_sku
                        season
                        brand
                        category
                        gender
                        product_name
                        product_size
                        supplier_style_code
                        supplier_color_code
                        supplier_product_name
                        supplier_color_name
                        brand_size
                        product_cost
                        status
                        order_id
                        order_date
                        ordered_quantity
                        ordered_cost
                        ordered_value
                        delivery_date
                        order_first_received
                        delivered_quantity
                        delivered_cost
                        delivered_value
                        cancelled_quantity
                        cancelled_cost
                        cancelled_value
                        operator
                        weeks_on_sale
                        closing_date
                        comment)

  def self.to_csv
    CSV.generate do |csv|
      csv << CSV_COLUMN_ORDER.map(&:humanize)

      where(nil).each do |purchase_order|
        csv << purchase_order.as_json({}).values_at(*CSV_COLUMN_ORDER.map(&:to_sym))
      end
    end
  end

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
      where('(drop_date < ? or (cancelled_date < ?))', context[:date_until], context[:date_until])
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
                 end
                 .compact
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

  scope :with_summary, -> { where.not(summary_id: '').where.not(summary_id: 0) }
  scope :with_valid_status, -> { where('purchase_orders.status in (-1,2,3,4,5)') }

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
                 product_rrp: :orderTool_RRP,

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

  def orderTool_LG
    Gender.string_from(super)
  end

  def brand
    vendor.try(:name)
  end

  def category
    Category.english.find_by(category_id: category_id).try(:name)
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

  def supplier_color_code
    product.try(:product_detail).try(:supplier_color_code)
  end

  def supplier_product_name
    product.try(:product_detail).try(:supplier_product_name)
  end

  def supplier_color_name
    product.try(:product_detail).try(:supplier_color_name)
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
    super.merge(po_number: po_number,
                product_cost: product_cost,
                product_size: product_size,
                product_rrp: product_rrp,
                category: category,
                brand: brand,
                supplier_style_code: supplier_style_code,
                supplier_color_code: supplier_color_code,
                supplier_product_name: supplier_product_name,
                supplier_color_name: supplier_color_name,
                order_id: id,
                order_type: order_type,
                order_first_received: order_first_received,
                ordered_quantity: ordered_quantity,
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
                weeks_on_sale: weeks_on_sale,
                closing_date: closing_date)
  end

  def cancel
    if status != -1
      update!({ cancelled_date: Date.today, status: -1 })
    end

    self
  end

  def cancel_order
    items = PurchaseOrder.with_summary.where(po_number: po_number)
    items.each do |item|
      item.cancel
    end
    items.map { |i| i.id }
  end

  private

  def monetize(figure)
    number_to_currency(figure, unit: '£')
  end
end
