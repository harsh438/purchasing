FactoryGirl.define do
  factory :order do
    name 'OT_100 (Hmm)'
    season :AW15

    transient do
      line_item_count 0
    end

    after(:create) do |order, evaluator|
      if evaluator.line_item_count > 0
        order.line_items = create_list(:order_line_item, evaluator.line_item_count)
      end
    end
  end
end
