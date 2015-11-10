FactoryGirl.define do
  factory :element do
    elementID { Faker::Name }
    elementname { Faker::Name }
  end
end
