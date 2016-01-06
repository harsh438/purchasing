FactoryGirl.define do
  factory :sku do
    manufacturer_sku 'MANU-FACTURER-SKU-11'
    season :AW15

    manufacturer_color :reddish
    manufacturer_size :biggish

    color :red
    size :big

    price 24.99
    cost_price 19.99
    list_price 29.99

    vendor

    product_id { create(:product).id }
    option_id { create(:option).id }
    language_product_option_id { create(:language_product_option, product_id: product_id, option_id: option_id).id }
    category_id { create(:language_category, category_id: create(:category).id).id }
    element_id { LanguageProductOption.find(language_product_option_id).elementID }

    after(:build) do |sku|
      sku.sku = "#{sku.product_id}-#{sku.element_id}"
    end

    trait :with_purchase_order_line_item do
      transient do
        purchase_order { create(:purchase_order) }
      end

      after(:build) do |sku, evaluator|
        create(:purchase_order_line_item, product_id: sku.product_id,
                                          option_id: sku.option_id,
                                          purchase_order: evaluator.purchase_order)
      end
    end
  end
end
