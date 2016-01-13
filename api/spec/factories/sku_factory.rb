FactoryGirl.define do
  factory :sku_without_barcode, class: Sku do
    sku { ((Sku.last.try(:id) || 0) + 1) *-1 }

    product_name 'An Example Product'
    manufacturer_sku 'MANU-FACTURER-SKU-11-reddish'
    season :AW15

    inv_track { 'O' }

    manufacturer_color :reddish
    manufacturer_size :biggish

    category_id { create(:language_category, category_id: create(:category).id).id }

    color :red
    size :big

    price 24.99
    cost_price 19.99
    list_price 29.99

    vendor

    factory :sku do
      product_id { create(:product, manufacturer_sku: 'MANU-FACTURER-SKU-11-reddish').id }
      option_id { create(:option).id }
      language_product_id { create(:language_product, product_id: product_id).id }
      language_product_option_id { create(:language_product_option, product_id: product_id, option_id: option_id).id }
      element_id { LanguageProductOption.find(language_product_option_id).elementID }

      after(:build) do |sku|
        sku.sku = "#{sku.product_id}-#{sku.element_id}"
        sku.barcodes << create(:barcode)
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
end
