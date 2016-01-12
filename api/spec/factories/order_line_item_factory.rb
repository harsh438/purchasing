FactoryGirl.define do
  factory :order_line_item do
    order
    internal_sku { create(:sku).sku }
    cost 1.00
    quantity 1
    discount 0
    drop_date { Time.now }
  end
end
