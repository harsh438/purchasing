FactoryGirl.define do
  factory :supplier do
    name { Faker::Name.name }
    returns_address_name { Faker::Name.name }
    returns_address_number { Faker::Address.building_number }
    returns_address_1 { Faker::Address.street_name }
    returns_postal_code { Faker::AddressUK.postcode }
    returns_process 'Just return it'

    transient do
      contact_count 0
    end

    after :create do |supplier, evaluator|
      if evaluator.contact_count > 0
        create_list(:supplier_contact, evaluator.contact_count, supplier: supplier)
      end
    end

    trait :with_details do
      after :create do |supplier|
        supplier.create_details!(invoicer_name: Faker::Name.name)
      end
    end

    trait :with_detail_attrs do
      invoicer_name { Faker::Name.name }
      account_number '011'
      country_of_origin { Faker::AddressUK.country }
      needed_for_intrastat { Faker::Boolean.maybe }
    end
  end
end
