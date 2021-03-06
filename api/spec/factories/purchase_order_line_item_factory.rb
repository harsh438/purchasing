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
    status 2
    sku { create(:base_sku, :with_product, :sized, :with_barcode) }

    # These should be blank.

    season :AW15
    vendor
    gender ''
    manufacturer_size 'MAN_SIZE'
    product_size 'SD_SIZE'

    trait :ready do
      status 2
    end

    trait :balance do
      status 4
      qty 10
      qtyAdded 0
      qtyDone 5
    end

    trait :sent_in_peoplevox do
      sent_to_peoplevox 1
    end

    trait :arrived do
      arrived_date 1.day.ago
    end

    trait :with_summary do
      purchase_order { |po| create(:purchase_order, vendor: po.vendor) }
    end

    trait :with_barcode do
      barcode { create(:barcode) }
    end

    trait :with_product do
      product { create(:product) }
    end

    trait :with_option do
      option { create(:option) }

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
