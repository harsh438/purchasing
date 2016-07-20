FactoryGirl.define do
  factory :product do
    pSale 0

    season 'ss18'
    manufacturer_sku '123456-123'
    vendor

    trait :with_skus do
      after(:create) do |product|
        product.skus += build_list(:sku, 2, vendor: product.vendor)
      end
    end

    trait :with_master_sku do
       after(:create) do |product|
        master = build(:sku, vendor: product.vendor)
        master.sku = product.id
        product.skus << master
      end
    end

    trait :with_reporting_category do
      after(:create) do |product|
        create(:reporting_category, pid: product.id)
      end
    end

    trait :with_pvx_in do
      after(:create) do |product, evaluator|
        create(:pvx_in, pid: product.id)
      end
    end

    trait :with_kit_managers do
      after(:create) do |product|
        create_list(:kit_manager, 2, product: product)
      end
    end

    after(:create) do |product, evaluator|
      create(:english_language_product, product: product)
      create(:language_product_option, product: product)
    end
  end
end
