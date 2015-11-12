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
    summary_id 1
    gender ''

    trait :arrived do
      arrived_date 1.day.ago
    end

    trait :with_product do
      product
    end

    trait :with_option do
      option_id 1

      after(:create) do |po, evaluator|
        create(:language_product_option, oID: po.option_id)
      end
    end
  end
end
