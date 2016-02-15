FactoryGirl.define do
  factory :purchase_order_line_item do
    # These are the minimum fields required for insertion.
    cost 10
    quantity 5
    created_at Time.now

    order_date 5.days.ago
    drop_date 4.days.ago
    invoice_payable_date 3.days.ago
    product_sku { Faker::Lorem.characters(32) }
    status 4
    sku

    # These should be blank.

    season :AW15
    vendor_id 0
    gender ''
    manufacturer_size 'MAN_SIZE'
    product_size 'SD_SIZE'

    trait :balanced do
      qty 10
      qtyAdded 0
      qtyDone 10
    end

    trait :arrived do
      arrived_date 1.day.ago
    end

    trait :with_summary do
      po_number { create(:purchase_order).id }
    end

    trait :with_barcode do
      barcode 'Sample Barcode'
    end

    trait :with_option do
      option_id { create(:option).id }

      after(:create) do |po, evaluator|
        create(:language_product_option, oID: po.option_id, pID: po.product.id || 1)
      end
    end

    trait :with_language_option do
      option_id 1

      after(:create) do |po, evaluator|
        create(:language_product_option, oID: po.option_id, pID: po.product.id || 1)
      end
    end
  end
end
