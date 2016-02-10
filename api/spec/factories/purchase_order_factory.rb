FactoryGirl.define do
  factory :purchase_order do
    drop_date { Time.now }
    vendor

    trait :with_line_items do
      line_items { build_list(:purchase_order_line_item, 4, vendor: vendor) }
    end

    trait :with_balance_line_items do
      line_items { build_list(:purchase_order_line_item, 2, :balanced, vendor: vendor) }
    end
  end
end
