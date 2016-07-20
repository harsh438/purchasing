FactoryGirl.define do
  factory :language_product do
    name { Faker::Name.name }
    teaser { Faker::Name.name }
    description { Faker::Name.name }
    email_display { Faker::Name.name }

    factory :french_language_product do
      language_id 3
    end

    factory :english_language_product do
      language_id 1
    end
  end
end
