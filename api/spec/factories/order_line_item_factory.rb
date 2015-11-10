FactoryGirl.define do
  factory :order_line_item do
    internal_sku '1000-100'
    cost 1.00
    quantity 1
    discount 0
    drop_date { Time.now }
  end
end
