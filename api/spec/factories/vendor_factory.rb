FactoryGirl.define do
  factory :vendor do
    name 'Adidad'

    trait :with_details do
      discontinued false
    end
  end
end
