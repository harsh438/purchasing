FactoryGirl.define do
  factory :category do
    transient do
      name { Faker::Name.name }
    end

    after(:create) do |category, evaluator|
      create(:english_language_category, category: category, name: evaluator.name)
    end
  end
end
