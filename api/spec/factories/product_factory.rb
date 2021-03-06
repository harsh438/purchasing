FactoryGirl.define do
  factory :product do
    transient do
      name { Faker::Commerce.product_name }
      vendor_name { Faker::Company.name }
      teaser { Faker::Company.bs }
      sized true
    end

    on_sale 0
    season { Season.first }
    manufacturer_sku { Faker::Code.ean }
    vendor { create(:vendor, name: vendor_name) }
    barcode { generate(:barcode_sequence) }
    cost { Faker::Commerce.price }
    price { Faker::Commerce.price }
    listing_genders 'U'
    color { Faker::Color.color_name }
    photo_width 1024
    active 'Y'

    after(:build) do |product|
      product.product_categories += create_list(:product_category, 2, product: product)
    end

    trait :with_skus do
      after(:create) do |product, evaluator|
        product.skus << build_list(
          :base_sku, 2, :with_product,
          :sized,
          :with_barcode,
          vendor: product.vendor,
          product: product,
          product_name: evaluator.name
        )
      end
    end

    trait :with_reporting_category do
      transient do
        reporting_category_name { Faker::Name.name }
      end

      after(:create) do |product, evaluator|
        create(:reporting_category, product: product, category_name: evaluator.reporting_category_name)
      end
    end

    trait :with_pvx_in do
      after(:create) do |product, _evaluator|
        create(:pvx_in, product: product)
      end
    end

    trait :with_kit_managers do
      after(:create) do |product|
        create_list(:kit_manager, 2, product: product)
      end
    end

    trait :with_gender do
      transient do
        gender 'U'
      end

      after(:create) do |product, evaluator|
        create(:product_gender, product: product, gender: evaluator.gender)
      end
    end

    after(:create) do |product, evaluator|
      create(:english_language_product, product: product, name: evaluator.name, teaser: evaluator.teaser)
      create(:language_product_option, product: product) if evaluator.sized
    end
  end
end
