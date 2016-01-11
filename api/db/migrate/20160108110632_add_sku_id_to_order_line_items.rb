class AddSkuIdToOrderLineItems < ActiveRecord::Migration
  def change
    add_reference :order_line_items, :sku, index: true

    reversible do |dir|
      dir.up do
        OrderLineItem.all.each(&method(:set_sku_id_on_order_line_item))
      end
    end
  end

  private

  def set_sku_id_on_order_line_item(order_line_item)
    order_line_item.update!(sku: Sku.find_by!(sku: order_line_item.internal_sku))
  rescue ActiveRecord::RecordNotFound => e
    raise "sku=#{order_line_item.internal_sku}  order_line_item_id=#{order_line_item.id}\n"
  end
end
