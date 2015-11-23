FactoryGirl.define do
  factory :supplier do
    name { Faker::Name.name }
    returns_address_name { Faker::Name.name }
    returns_address_number { Faker::Address.building_number }
    returns_address_1 { Faker::Address.street_name }
    returns_postal_code { Faker::AddressUK.postcode }
    returns_process 'Just return it'

    trait :with_details do
      invoicer_name { Faker::Name.name }
      account_number '011'
      country_of_origin { Faker::AddressUK.country }
      needed_for_intrastat { Faker::Boolean.maybe }
    end
  end
end
