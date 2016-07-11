FactoryGirl.define do
  factory :refused_deliveries_log do
    delivery_date 5.days.ago

    trait :with_details do
        delivery_date Date.today.to_s(:db)
        courier { Faker::Name.name }
        brand_id 4
        pallets 5
        boxes 50
        info { Faker::Lorem.sentence(3) }
        refusal_reason { Faker::Lorem.sentence(3) }
    end
  end
end
