FactoryGirl.define do
  factory :language_category do
    langID 1
    catID 50
    catName { Faker::Name.name }
    catDesc "Desc"
  end

  trait :with_a_category do
    after(:create) do |language_category|
      create(:category, catID: language_category.catID)
    end
  end
end
