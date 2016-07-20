FactoryGirl.define do
  factory :sku_without_barcode, class: Sku do
    product_name 'An Example Product'
    manufacturer_sku 'MANU-FACTURER-SKU-11-reddish'
    season :AW15
    inv_track 'O'
    manufacturer_color :reddish
    manufacturer_size :biggish
    language_category
    color :red
    size :big
    price 24.99
    cost_price 19.99
    list_price 29.99
    gender 'M'
    listing_genders 'M'
    vendor
    product { |sku| create(:product, manufacturer_sku: sku.manufacturer_sku) }
    option
    language_product
    language_product_option
    element { |sku| language_product_option.element }
    sku { |s| [s.product.id * -1, s.manufacturer_sku].join("-") }

    trait :with_old_season do
      season :AW02
    end

    trait :without_updated_date do
      updated_at nil
      record_timestamps false
    end

    trait :with_old_updated_date do
      updated_at 1.year.ago
      record_timestamps false
    end

    trait :with_recent_updated_date do
      updated_at 5.minutes.ago
      record_timestamps false
    end

    trait :with_fixed_updated_date do
      record_timestamps false
      # does not matter which date it is as long as it's really old and the same
      updated_at Time.parse('1948-02-18T17:26:26')
    end

    trait :unsized do
      inv_track 'P'
    end

    factory :sku do
      transient do
        barcode { create(:barcode) }
      end

      sku { |s| [s.product.id, s.manufacturer_sku].join("-") }

      after(:build) do |sku, evaluator|
        sku.barcodes << evaluator.barcode
      end
    end

    trait :with_purchase_order_line_item do
      transient do
        purchase_order { create(:purchase_order) }
      end

      after(:build) do |sku, evaluator|
        create(
          :purchase_order_line_item,
          product: sku.product,
          option: sku.option,
          purchase_order: evaluator.purchase_order,
          sku: sku
        )
      end
    end
  end
end
