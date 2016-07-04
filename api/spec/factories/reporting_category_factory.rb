FactoryGirl.define do
  factory :reporting_category do
    transient do
      category_name { Faker::Name.name }
    end

    product
    category { create(:category, name: category_name) }
  end
end
