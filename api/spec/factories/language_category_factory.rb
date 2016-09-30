FactoryGirl.define do
  factory :language_category do
    language_id 1
    name { Faker::Name.name }
    category { |lang_cat| create(:category, name: lang_cat.name) }
    description 'Desc'

    factory :english_language_category do
      language_id 1
    end

    factory :french_language_category do
      language_id 3
    end
  end
end
