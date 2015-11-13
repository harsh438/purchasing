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
        order_line_item.internal_sku = "#{product.id}-1"
      end
    end
  end
end
