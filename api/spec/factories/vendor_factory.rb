FactoryGirl.define do
  factory :vendor do
    name { Faker::Name.name }

    trait :with_details do
      discontinued false
    end

    trait :without_updated_date do
      updated_at nil
      record_timestamps false
    end

    trait :with_old_updated_date do
      updated_at 1.year.ago
    end

    trait :with_recent_updated_date do
      updated_at 5.minutes.ago
    end
  end
end
