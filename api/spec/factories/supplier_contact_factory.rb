FactoryGirl.define do
  factory :supplier_contact do
    name { Faker::Name.name }
    title { Faker::Company.profession }
    mobile { Faker::PhoneNumber.phone_number }
    landline { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
  end
end
