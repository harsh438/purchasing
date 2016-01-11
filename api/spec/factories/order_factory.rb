FactoryGirl.define do
  factory :order do
    transient do
      line_item_count 0
    end

    after(:create) do |order, evaluator|
      if evaluator.line_item_count > 0
        order.line_items = create_list(:order_line_item, evaluator.line_item_count, :with_sku)
      end
    end
  end
end
