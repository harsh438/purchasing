FactoryGirl.define do
  factory :language_product do
    name { Faker::Name.name }
    teaser { Faker::Name.name }
    pDesc { Faker::Name.name }
    pCallEmailDisplay { Faker::Name.name }
  end
end
