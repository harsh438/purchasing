class Order::LineItemAdder
  def add(order, line_items_attrs)
    standardize(line_items_attrs).each do |line_item_attrs|
      sku = find_sku(line_item_attrs)
      order.line_items.create!(line_item_and_sku_attrs(line_item_attrs, sku))
    end
  end

  private

  def standardize(line_item_attrs)
    if line_item_attrs.is_a?(Hash)
      line_item_attrs.values
    else
      line_item_attrs || []
    end
  end

  def find_sku(line_item_attrs)
    if line_item_attrs[:internal_sku].starts_with?('-')
      Sku.find_by!(sku: line_item_attrs[:internal_sku],
                   season: line_item_attrs[:season],
                   manufacturer_size: line_item_attrs[:manufacturer_size])
    else
      Sku.order(created_at: :desc).find_by!(sku: line_item_attrs[:internal_sku])
    end
  end

  def line_item_and_sku_attrs(line_item_attrs, sku)
    { sku: sku,
      internal_sku: sku.sku,
      cost: line_item_attrs[:cost],
      quantity: line_item_attrs[:quantity],
      discount: line_item_attrs[:discount],
      drop_date: line_item_attrs[:drop_date],
      product_id: sku.product_id,
      option_id: sku.option_id || 0,
      vendor_id: sku.vendor_id,
      season: sku.season,
      product_name: sku.product_name,
      gender: sku.gender,
      reporting_pid: sku.product_id }
  end
end
