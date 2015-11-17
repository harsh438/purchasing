FactoryGirl.define do
  sequence(:internal_sku) { |i| "#{i}-100" }

  factory :order_line_item do
    internal_sku
    cost 1.00
    quantity 1
    discount 0
    drop_date { Time.now }

    after(:build) do |order_line_item|
      unless order_line_item.vendor_id.present?
        product = create(:product, vendor_id: create(:vendor).id)
        po_line = create(:purchase_order_line_item, :with_option)
        order_line_item.internal_sku = "#{product.id}-#{Element.id_from_option(po_line.option_id)}"
      end
    end
  end
end
