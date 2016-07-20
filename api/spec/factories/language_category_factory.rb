FactoryGirl.define do
  factory :language_category do
    language_id 1
    category
    name { Faker::Name.name }
    description "Desc"

    factory :english_language_category do
      language_id 1
    end

    factory :french_language_category do
      language_id 3
    end
  end
end
