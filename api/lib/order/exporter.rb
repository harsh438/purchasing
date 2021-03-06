class Order::Exporter
  def export(orders, extra_params = {})
    extra_params = extra_params.with_indifferent_access

    ActiveRecord::Base.transaction do
      GroupedOrders.new(orders).flat_map do |vendor_id, drop_date, order_line_items, orders|
        assign_po_to_orders(create_po(order_line_items, extra_params), orders)
      end
    end
  end

  private

  def create_po(order_line_items, extra_params)
    PurchaseOrder.create!(vendor_id: order_line_items.first.vendor_id,
                          vendor_name: order_line_items.first.vendor_name,
                          operator: extra_params[:operator] || operator(order_line_items.first),
                          order_type: order_type(order_line_items.first),
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
    {
      operator: extra_params[:operator] || operator(order_line_item),
      single_line_id: extra_params[:single_line_id] || nil,
      line_id: order_line_item.sku.try(:order_tool_reference) || 0,
      reporting_pid: order_line_item.reporting_pid,
      quantity_done: extra_params[:quantity_done] || 0,
      status: extra_params.fetch(:status, 2)
    }
      .merge(po_line_item_core_attrs(order_line_item))
      .merge(po_line_item_relationship_attrs(order_line_item))
      .merge(po_line_item_product_attrs(order_line_item))
      .merge(po_line_item_size_attrs(order_line_item))
      .merge(po_line_item_date_attrs(order_line_item))
  end

  def attempt_barcode(order_line_item)
    order_line_item.sku.try(:barcodes).try(:first).try(:barcode)
  end

  def po_line_item_core_attrs(order_line_item)
    { supplier_cost_price: order_line_item.cost,
      cost: order_line_item.discounted_cost,
      quantity: order_line_item.quantity,
      season: order_line_item.season || '',
      gender: order_line_item.gender || '',
      sku: order_line_item.sku,
      category_id: order_line_item.sku.language_category.category.id,
      barcode: attempt_barcode(order_line_item) }
  end

  def po_line_item_date_attrs(order_line_item)
    { order_date: order_line_item.order.created_at,
      drop_date: order_line_item.drop_date }
  end

  def po_line_item_relationship_attrs(order_line_item)
    { product_id: order_line_item.product_id || 0,
      vendor_id: order_line_item.vendor_id,
      option_id: order_line_item.option_id || 0 }
  end

  def language_option(product_id, option_id)
    LanguageProductOption.find_by(product_id: product_id, option_id: option_id)
  end

  def po_line_item_product_attrs(order_line_item)
    { product_rrp: order_line_item.sku.price,
      product_sku: order_line_item.sku.manufacturer_sku[0..63],
      product_name: order_line_item.product_name }
  end

  def po_line_item_size_attrs(order_line_item)
    language_product_option = language_option(order_line_item.product_id,
                                              order_line_item.option_id)

    { product_size: order_line_item.sku.size,
      manufacturer_size: order_line_item.sku.manufacturer_size }
  end

  def assign_po_to_orders(purchase_order, orders)
    orders.each do |order|
      order.purchase_orders << purchase_order
    end
  end

  def operator(order_line_item)
    case order_line_item.order.order_type
    when 'preorder'
      order_line_item.order.name.split(' ').first
    else
      'REORDER_TOOL'
    end
  end

  def order_type(order_line_item)
    OrderType.char_from(order_line_item.order.order_type) || 'R'
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
