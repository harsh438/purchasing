class Order::Exporter
  def export(orders)
    group_order_line_items_by_drop_date(orders).flat_map do |orders, order_line_items|
      assign_po_to_orders(create_po(order_line_items), orders)
    end
  end

  private

  def order_line_items_by_drop_date(order_line_items)
    by_drop_date = Hash.new { |h, k| h[k] = [] }

    order_line_items.reduce(by_drop_date) do |by_drop_date, order_line_item|
      by_drop_date[order_line_item.drop_date.to_date.to_s] << order_line_item
      by_drop_date
    end
  end

  def group_order_line_items_by_drop_date(orders)
    order_line_items_by_drop_date(orders.flat_map(&:line_items)).reduce([]) do |grouped_order_line_items, (drop_date, order_line_items)|
      grouped_order_line_items << [order_line_items.map(&:order).uniq, order_line_items]
    end
  end

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
end
