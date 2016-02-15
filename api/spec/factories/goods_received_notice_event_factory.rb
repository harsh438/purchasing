FactoryGirl.define do
  factory :goods_received_notice_event do
    purchase_order { create(:purchase_order, :with_balance_line_items) }
    units 10
    cartons 1
    pallets 1
    status 1
    user

    trait :for_today do
      delivery_date Date.today
    end

    after(:build) do |grn_event|
      grn_event.vendor_id = grn_event.purchase_order.vendor_id

      if grn_event.delivery_date.past?
        grn_event.status = [2, 2, 2, 4, 4, 4, 4, 7, 1].sample
      end
    end
  end
end
