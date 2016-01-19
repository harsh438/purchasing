FactoryGirl.define do
  factory :order_line_item do
    order
    cost 1.00
    quantity 1
    discount 0
    drop_date { Time.now }

    after(:build) do |order_line_item|
      order_line_item.sku ||= create(:sku)
      order_line_item.internal_sku ||= order_line_item.sku.sku
      order_line_item.product_id ||= order_line_item.sku.product_id
      order_line_item.option_id ||= order_line_item.sku.option_id
      order_line_item.vendor_id ||= order_line_item.sku.vendor_id
    end
  end
end
