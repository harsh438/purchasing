FactoryGirl.define do
  factory :product do
    pSale 0

    season 'ss18'
    manufacturer_sku '123456-123'
    vendor

    trait :with_skus do
      after(:create) do |product|
        master = build(:sku, vendor: product.vendor)
        master.sku = product.id
        product.skus << master
        product.skus += build_list(:sku, 2, vendor: product.vendor)
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
        create_list(:kit_manager, 2, pID: product.id)
      end
    end

    after(:create) do |product, evaluator|
      option = create(:option)
      create(:language_product, product_id: product.id)
      create(:language_product_option, product_id: product.id,
                                       option_id: option.id)
    end
  end
end
