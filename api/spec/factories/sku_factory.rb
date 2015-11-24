FactoryGirl.define do
  factory :sku do
    sku '11111-111'
    manufacturer_sku 'MANU-FACTURER-SKU-11'
    season :AW15

    manufacturer_color :reddish
    manufacturer_size :biggish

    color :red
    size :big

    price 24.99
    cost_price 19.99
    list_price 29.99

    product_id { create(:product).id }
    option_id { create(:language_product_option, pID: product_id).id }
    element_id { ProductOption.find(option_id).elementID }
  end
end