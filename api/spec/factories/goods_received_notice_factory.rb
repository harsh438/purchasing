FactoryGirl.define do
  factory :goods_received_notice do
    delivery_date { Date.today }
    units 10
    cartons 2
    pallets 2

    order

    # must be set
    received 0
    checking 0
    checked 0
    processing 0
    processed 0
    received_at '0001-01-01'
    page_count 0
    units_received 0
    cartons_received 0
  end
end
