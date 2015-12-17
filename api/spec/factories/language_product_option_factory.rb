FactoryGirl.define do
  sequence(:pOption) { |i| "o#{i}" }
  sequence(:oID) { |i| i }

  factory :language_product_option do
    pID 1
    oID
    langID 1
    pOption

    after(:build) do |language_product_option, evaluator|
      element = create(:element, elementname: language_product_option.pOption)
      language_product_option.element_id = element.id
    end
  end
end
