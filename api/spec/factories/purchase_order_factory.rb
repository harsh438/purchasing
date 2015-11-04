FactoryGirl.define do
  factory :purchase_order do

    # These are the minimum fields required for insertion.
    quantity 5
    created_at Time.now

    order_date 5.days.ago
    drop_date 4.days.ago
    invoice_payable_date 3.days.ago

    # These should be blank.
    arrived_date 100.years.ago
    cancelled_date 100.years.ago

    season :AW15
    vendor_id 0
    reporting_product_id 0
    original_product_id 0
    original_option_id 0
    summary_id 1
    gender ''
    line_id 0

    trait :arrived do
      arrived_date 1.day.ago
    end

    trait :with_product do
      product
    end

    trait :with_option do
      option_id 1
    end
  end
end
