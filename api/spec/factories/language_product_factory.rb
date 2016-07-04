FactoryGirl.define do
  factory :language_product do
    name { Faker::Commerce.product_name }
    teaser { Faker::Company.bs }
    description { Faker::Lorem.sentence }
    email_display { Faker::Name.name }

    factory :french_language_product do
      language_id 3
    end

    factory :english_language_product do
      language_id 1
    end
  end
end
