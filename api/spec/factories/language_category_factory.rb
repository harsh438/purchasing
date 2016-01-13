FactoryGirl.define do
  factory :language_category do
    langID 1
    catName { Faker::Name.name }
    category
  end
end
