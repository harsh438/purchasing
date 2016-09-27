FactoryGirl.define do
  factory :season do
    name { %w(SS AW).sample }
    year { Date.today.year.to_s }
    nickname { |s| s.name + s.year[-2, 2] }
    sort { (1..10).to_a.sample }
  end
end
