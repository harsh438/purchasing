class Order::ErroneousOrders
  def fix
    Order.find_in_batches.each do |group|
      group.each do |order|
        order_line_items = order.line_items.joins('JOIN skus ON order_line_items.internal_sku = skus.sku')
                                           .where("internal_sku LIKE '-%'")
                                           .where(skus: { inv_track: 'O' })

        ActiveRecord::Base.transaction do
          order_line_items.map do |order_line_item|
            negative_pid = order_line_item.internal_sku
            quantity = order_line_item.quantity

            legacy_order_lines(negative_pid).map do |legacy_item|
              first_line_item = find_first_order_line_of_negative_pid_and_quantity(negative_pid, quantity)

              previous_sku_id = first_line_item.sku_id
              previous_internal_sku = first_line_item.internal_sku

              if previous_internal_sku.nil?
                p :no_sku, first_line_item
                exit
              end

              old_sku = Sku.find_by(sku: previous_internal_sku)
              new_sku = find_or_create_sku(negative_pid, old_sku, legacy_item)
              first_line_item.update!(sku: new_sku)
              # po_line_items = PurchaseOrderLineItem.where(sku_id: previous_sku_id)
              # po_line_items.update_all(sku_id: new_sku.id)
              p "line_item=#{first_line_item.id}  old_sku=#{old_sku.id}  sku=#{new_sku.id}  po_line_items=#{po_line_items.map(&:id)}"
              raise "Uh oh"
            end
          end
        end
      end
    end
  end

  private

  def legacy_order_lines(negative_pid)
    LegacyOrderLineItem.find(negative_pid.to_i * -1).sizes
  end

  def find_first_order_line_of_negative_pid_and_quantity(negative_pid, quantity)
    order.line_items.find_by(internal_sku: negative_pid, quantity: quantity)
  end

  def sku_attrs(negative_pid, old_sku, legacy_item)
    { sku: negative_pid,
      internal_sku: old_sku.sku,
      manufacturer_sku: old_sku.manufacturer_sku,
      manufacturer_color: old_sku.manufacturer_color,
      vendor_id: old_sku.vendor_id,
      product_name: old_sku.product_name,
      season: old_sku.season,
      color: old_sku.color,
      inv_track: old_sku.inv_track,
      lead_gender: old_sku.gender,
      category_id: old_sku.category_id,
      manufacturer_size: legacy_item.manufacturer_size,
      size: legacy_item.size,
      cost_price: legacy_item.cost_price,
      list_price: legacy_item.list_price,
      price: legacy_item.price }
  end

  def find_or_create_sku(negative_pid, old_sku, legacy_item)
    Sku::Generator.new.generate(sku_attrs(negative_pid, old_sku, legacy_item))
  end
end
