FactoryGirl.define do
  factory :goods_received_notice do
    delivery_date { Date.today }
    units { rand(5...50) }
    cartons { rand(2...20) }
    pallets { rand (1...10) }

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

    trait :give_or_take_2_weeks do
      delivery_date { rand(2.weeks.ago..2.weeks.from_now) }
    end
  end
end
