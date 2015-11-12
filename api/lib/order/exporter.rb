class Order::Exporter
  def export(orders)
    group_order_line_items_by_brand_and_drop_date(orders).flat_map do |orders, order_line_items|
      assign_po_to_orders(create_po(order_line_items), orders)
    end
  end

  private

  def group_order_line_items_by_brand_and_drop_date(orders)
    [[orders, orders.flat_map(&:line_items)]]
  end

  def export_order_line_items(order_line_items)
    assign_po_to_orders()
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
