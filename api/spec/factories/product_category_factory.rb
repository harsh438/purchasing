FactoryGirl.define do
  factory :product_category do
    product
    category
    sort_order 999
  end
end
