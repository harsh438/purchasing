FactoryGirl.define do
  factory :sku_without_barcode, class: Sku do
    product_name { Faker::Commerce.product_name }
    manufacturer_sku 'MANU-FACTURER-SKU-11-reddish'
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
    order_tool_reference 1010105
    vendor
    sku { |s| [((Sku.last.try(:id) || 0) + 1) * -1, s.manufacturer_sku].join('-') }
    season { Season.first }

    trait :with_old_season do
      season { Season.last }
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

      product { |sku| create(:product, manufacturer_sku: sku.manufacturer_sku, season: sku.season) }
      sku { |s| [s.product.id, s.manufacturer_sku].join('-') }
      vendor { |sku| product.vendor }
      option { |sku| create(:option, size: sku.manufacturer_size) }
      language_product { |sku| create(:english_language_product, name: sku.product_name) }
      language_product_option
      element { |sku| language_product_option.element }

      after(:build) do |sku, evaluator|
        sku.barcodes << evaluator.barcode if evaluator.barcode.present?
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

FactoryGirl.define do
  factory :unsized_sku, class: Sku do

    product
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
  end
end

FactoryGirl.define do
  factory :sku_without_product, class: Sku do

    product_name { Faker::Commerce.product_name }
    manufacturer_sku 'MANU-FACTURER-SKU-11-reddish'
    inv_track 'O'
    manufacturer_color :reddish
    language_category
    manufacturer_size :biggish
    size :big
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
  end
end
