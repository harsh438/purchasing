FactoryGirl.define do
  factory :goods_received_notice_event do
    purchase_order
    units { 10 }
    cartons { 1 }
    pallets { 1 }

    after(:build) do |grn_event|
      grn_event.vendor_id = grn_event.purchase_order.id
    end
  end
end
