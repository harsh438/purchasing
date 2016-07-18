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

    after(:create) do |product, evaluator|
      option = create(:option)
      create(:language_product, product_id: product.id)
      create(:language_product_option, product_id: product.id,
                                       option_id: option.id)
    end
  end
end
