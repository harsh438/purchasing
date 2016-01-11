FactoryGirl.define do
  factory :order_line_item do
    internal_sku do
      product = create(:product, vendor_id: create(:vendor).id)
      po_line = create(:purchase_order_line_item, :with_option, product: product)
      internal_sku = "#{product.id}-#{Element.id_from_option(product.id, po_line.option_id)}"
      internal_sku
    end

    cost 1.00
    quantity 1
    discount 0
    drop_date { Time.now }

    trait :with_sku do
      after(:build) do |order_line_item|
        order_line_item.sku = create(:sku, product_id: order_line_item.product_id,
                                           option_id: order_line_item.option_id)
      end
    end
  end
end
