FactoryGirl.define do
  sequence(:barcode_sequence) { |i| "3283292#{i}" }
  factory :barcode do
    barcode { generate :barcode_sequence }

    trait :week_old do
      updated_at { 1.week.ago }
      record_timestamps false
    end
  end
end
