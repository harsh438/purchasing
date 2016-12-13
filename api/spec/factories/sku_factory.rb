FactoryGirl.define do
  factory :base_sku, class: Sku do
    product_name { Faker::Commerce.product_name }
    manufacturer_sku 'MANU-FACTURER-SKU-11-reddish'
    inv_track 'P'
    manufacturer_color :reddish
    language_category
    color :red
    price 24.99
    cost_price 19.99
    list_price 29.99
    gender 'M'
    listing_genders 'M'
    order_tool_reference 1010105
    vendor
    sku { |s| [((Sku.last.try(:id) || 0) + 1) * -1, s.manufacturer_sku].join('-') }
    season { Season.first }
    language_product { |sku| create(:english_language_product, name: sku.product_name) }

    trait :sized do
      manufacturer_size :biggish
      option { |sku| create(:option, size: sku.manufacturer_size) }
      language_product_option
      element { |sku| sku.language_product_option.element }
      inv_track 'O'
      size :big
    end

    trait :with_product do
      product { |sku| create(:product, manufacturer_sku: sku.manufacturer_sku, season: sku.season, cost: 9.99) }
    end

    trait :with_barcode do
      transient do
        barcode { create(:barcode) }
      end

      after(:build) do |sku, evaluator|
        sku.barcodes << evaluator.barcode if evaluator.barcode.present?
      end
    end

    trait :with_old_updated_date do
      updated_at 1.year.ago
      record_timestamps false
    end

    trait :with_old_season do
      season { Season.last }
    end

    trait :without_updated_date do
      updated_at nil
      record_timestamps false
    end

    trait :with_recent_updated_date do
      updated_at 5.minutes.ago
      record_timestamps false
    end

    trait :with_old_updated_date do
      updated_at 1.year.ago
      record_timestamps false
    end

    trait :with_fixed_updated_date do
      record_timestamps false
      # does not matter which date it is as long as it's really old and the same
      updated_at Time.parse('1948-02-18T17:26:26')
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
