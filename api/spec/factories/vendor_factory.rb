FactoryGirl.define do
  factory :vendor do
    name { Faker::Name.name }

    trait :with_details do
      discontinued false
    end
  end
end
