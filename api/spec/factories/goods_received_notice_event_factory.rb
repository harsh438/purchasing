FactoryGirl.define do
  factory :goods_received_notice_event do
    purchase_order
    units 10
    cartons 1
    pallets 1
    status 1

    after(:build) do |grn_event|
      grn_event.vendor_id = grn_event.purchase_order.vendor_id

      if grn_event.delivery_date.past?
        grn_event.status = [2, 2, 2, 4, 4, 4, 4, 7].sample
      end
    end
  end
end
