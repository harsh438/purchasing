class AddSkuIdToOrderLineItems < ActiveRecord::Migration
  def change
    unless column_exists?(:order_line_items, :sku_id)
      add_reference :order_line_items, :sku, index: true
    end

    reversible do |dir|
      dir.up do
        OrderLineItem.all.each(&method(:set_sku_id_on_order_line_item))
      end
    end
  end

  private

  def set_sku_id_on_order_line_item(order_line_item)
    order_line_item.quantity = 1 if order_line_item.quantity < 1
    order_line_item.update!(sku: Sku.find_by!(sku: order_line_item.internal_sku))
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("sku=#{order_line_item.internal_sku}  order_line_item_id=#{order_line_item.id}")
  end
end
