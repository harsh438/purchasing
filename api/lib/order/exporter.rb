class Order::Exporter
  def export(orders)
    GroupedOrders.new(orders).flat_map do |vendor_id, drop_date, order_line_items, orders|
      assign_po_to_orders(create_po(order_line_items), orders)
    end
  end

  private

  def create_po(order_line_items)
    PurchaseOrder.create!(line_items: create_po_line_items(order_line_items),
                          drop_date: order_line_items.first.drop_date)
  end

  def create_po_line_items(order_line_items)
    order_line_items.map do |order_line_item|
      create_po_line_item(order_line_item)
    end
  end

  def create_po_line_item(order_line_item)
    PurchaseOrderLineItem.create!(order_date: order_line_item.order.created_at,
                                  drop_date: order_line_item.drop_date,
                                  po_season: 'AW16',
                                  gender: 'M')
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
        map do |vendor_id, by_drop_date|
          orders = by_drop_date.values.flatten.map(&:order).uniq
          [vendor_id, by_drop_date.flatten, [orders]].flatten(1)
        end
      end
    end
  end
end
