FactoryGirl.define do
  sequence(:barcode_sequence) { |i| "3283292#{i}" }
  factory :barcode do
    barcode { generate :barcode_sequence }
  end
end
