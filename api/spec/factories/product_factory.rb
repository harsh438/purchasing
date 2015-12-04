FactoryGirl.define do
  factory :product do
    pSale 0

    vendor_id { create(:vendor).id }

    after(:create) do |product, evaluator|
      create(:language_product, product_id: product.id)
    end
  end
end
