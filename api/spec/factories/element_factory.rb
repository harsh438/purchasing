FactoryGirl.define do
  sequence(:elementname) { |i| "o#{i}" }
  sequence(:elementID) { |i| i + 1000 }
  factory :element do
    elementID
    elementname
  end
end
