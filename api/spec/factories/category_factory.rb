FactoryGirl.define do
  factory :category do
    after(:create) do |category|
      create(:english_language_category, category: category)
    end
  end
end
