FactoryGirl.define do
  factory :vendor do
    sequence(:id) { |n| n + 1000 }
    name { Faker::Company.name }

    trait :with_details do
      discontinued false
    end

    trait :without_updated_date do
      updated_at nil
      record_timestamps false
    end

    trait :with_old_updated_date do
      updated_at DateTime.parse('2015-02-18T17:26:26').to_s(:db)
    end

    trait :with_recent_updated_date do
      updated_at 5.minutes.ago
    end

    trait :with_fixed_updated_date do
      # does not matter which date it is as long as it's the same
      updated_at DateTime.parse('2016-02-18T17:26:26').to_s(:db)
    end
  end
end
