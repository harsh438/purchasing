FactoryGirl.define do
  factory :language_product do
    name { Faker::Name.name }
    teaser { Faker::Name.name }
    pDesc { Faker::Name.name }
    pCallEmailDisplay { Faker::Name.name }
  end

  trait :french do
    after(:build) do |language_product|
      language_product.langID = 3
    end
  end

    trait :english do
    after(:build) do |language_product|
      language_product.langID = 1
    end
  end
end
