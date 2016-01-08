class AddSkuIdToOrderLineItems < ActiveRecord::Migration
  def change
    add_reference :order_line_items, :sku, index: true

    reversible do |dir|
      dir.up do
        OrderLineItem.all.each do |order_line_item|
          order_line_item.update!(sku: Sku.find_by!(sku: order_line_item.internal_sku))
        end
      end
    end
  end
end
