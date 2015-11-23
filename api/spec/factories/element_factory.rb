FactoryGirl.define do
  sequence(:elementname) { |i| "o#{i}" }
  sequence(:elementID) { |i| i }
  factory :element do
    elementID
    elementname
  end
end
