FactoryGirl.define do
  factory :purchase_order_line_item do

    # These are the minimum fields required for insertion.
    quantity 5
    created_at Time.now

    order_date 5.days.ago
    drop_date 4.days.ago
    invoice_payable_date 3.days.ago

    # These should be blank.

    season :AW15
    vendor_id 0
    gender ''

    trait :arrived do
      arrived_date 1.day.ago
    end

    trait :with_summary do
      summary_id { create(:purchase_order).id }
    end

    trait :with_option do
      option_id 1

      after(:create) do |po, evaluator|
        create(:language_product_option, oID: po.option_id, pID: po.product.id || 1)
      end
    end
  end
end
