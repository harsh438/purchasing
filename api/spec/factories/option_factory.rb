FactoryGirl.define do
  factory :option do
    name { Faker::Name.name }
    size "Small"
  end
end
