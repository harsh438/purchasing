class Order::Exporter
  def export(orders, extra_params = {})
    extra_params = extra_params.with_indifferent_access
    GroupedOrders.new(orders).flat_map do |vendor_id, drop_date, order_line_items, orders|
      assign_po_to_orders(create_po(order_line_items, extra_params), orders)
    end
  end

  private

  def create_po(order_line_items, extra_params)
    PurchaseOrder.create!(vendor_id: order_line_items.first.vendor_id,
                          vendor_name: order_line_items.first.vendor_name,
                          operator: extra_params[:operator] || 'REORDER_TOOL',
                          order_type: OrderType.char_from(order_line_items.first.order.order_type) || 'R',
                          line_items: create_po_line_items(order_line_items, extra_params),
                          drop_date: order_line_items.first.drop_date)
  end

  def create_po_line_items(order_line_items, extra_params)
    order_line_items.map do |order_line_item|
      create_po_line_item(order_line_item, extra_params)
    end
  end

  def create_po_line_item(order_line_item, extra_params)
    PurchaseOrderLineItem.create!(po_line_item_attrs(order_line_item, extra_params))
  end

  def po_line_item_attrs(order_line_item, extra_params)
    { operator: extra_params[:operator] || 'REORDER_TOOL',
      single_line_id: extra_params[:single_line_id] || nil,
      reporting_pid: order_line_item.reporting_pid }
      .merge!(po_line_item_core_attrs(order_line_item))
      .merge!(po_line_item_relationship_attrs(order_line_item))
      .merge!(po_line_item_product_attrs(order_line_item))
      .merge!(po_line_item_size_attrs(order_line_item))
      .merge!(po_line_item_date_attrs(order_line_item))
  end

  def attempt_barcode(order_line_item)
    barcode = Option.find_by(id: order_line_item.option_id).try(:barcode)
    return barcode if barcode.present?

    barcode = order_line_item.product.barcode
    return barcode if barcode.present?

    sku = Sku.find_by(sku: order_line_item.internal_sku)
    return sku.try(:barcodes).try(:first).try(:barcode)
  end

  def po_line_item_core_attrs(order_line_item)
    { status: 2,
      supplier_list_price: order_line_item.product.cost,
      cost: order_line_item.discounted_cost,
      quantity: order_line_item.quantity,
      season: order_line_item.season || '',
      gender: order_line_item.gender || '',
      barcode: attempt_barcode(order_line_item) }
  end

  def po_line_item_date_attrs(order_line_item)
    { order_date: order_line_item.order.created_at,
      drop_date: order_line_item.drop_date }
  end

  def po_line_item_relationship_attrs(order_line_item)
    { product_id: order_line_item.product_id,
      vendor_id: order_line_item.vendor_id,
      option_id: order_line_item.option_id || 0 }
  end

  def language_option(product_id, option_id)
    LanguageProductOption.find_by(product_id, option_id)
  end

  def po_line_item_product_attrs(order_line_item)
    { product_rrp: order_line_item.product.price,
      product_sku: order_line_item.product.manufacturer_sku,
      product_name: order_line_item.product_name }
  end

  def po_line_item_size_attrs(order_line_item)
    language_product_option = language_option(order_line_item.product_id,
                                              order_line_item.option_id)

    { product_size: Option.find(order_line_item.option_id).try(:size),
      manufacturer_size: language_product_option.name }
  end

  def assign_po_to_orders(purchase_order, orders)
    orders.each do |order|
      order.purchase_orders << purchase_order
    end
  end

  class GroupedOrders < Array
    def initialize(orders)
      super(group_order_line_items_by_vendor_and_drop_date(orders))
    end

    private

    def group_order_line_items_by_vendor_and_drop_date(orders)
      orders.flat_map(&:line_items).reduce(ByVendorAndDropDate.new, &:<<).flatten
    end

    class ByVendorAndDropDate < Hash
      def initialize
        super do |h, k|
          h[k] = Hash.new { |h, k| h[k] = [] }
        end
      end

      def <<(order_line_item)
        vendor_id = order_line_item.vendor_id
        drop_date = order_line_item.drop_date.to_date.to_s

        self[vendor_id][drop_date] << order_line_item
        self
      end

      def flatten
        flat_map do |vendor_id, by_drop_date|
          by_drop_date.map do |drop_date, order_line_items|
            orders = order_line_items.map(&:order).uniq
            [vendor_id, drop_date, order_line_items, orders]
          end
        end
      end
    end
  end
end
