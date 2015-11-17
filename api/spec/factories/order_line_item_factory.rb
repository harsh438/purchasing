FactoryGirl.define do
  sequence(:internal_sku) { |i| "1-1" }

  factory :order_line_item do
    internal_sku do
      product = create(:product, vendor_id: create(:vendor).id)
      po_line = create(:purchase_order_line_item, :with_option, product: product)
      internal_sku = "#{product.id}-#{Element.id_from_option(po_line.option_id)}"
      internal_sku
    end

    cost 1.00
    quantity 1
    discount 0
    drop_date { Time.now }
  end
end
