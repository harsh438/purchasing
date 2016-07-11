FactoryGirl.define do
  factory :product_category do
    pID 12
    catID 420
    sortOrder 999
  end

  trait :with_category do
    after(:create) do |product_category|
      create(:category, catID: product_category.catID)
    end
  end

  trait :with_different_parentID do
    after(:create) do |product_category|
      create(:category, catID: product_category.catID, parentID: 50)
    end
  end
end
