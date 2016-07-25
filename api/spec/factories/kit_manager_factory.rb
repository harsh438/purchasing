FactoryGirl.define do
  factory :kit_manager do
    barcode { generate :barcode_sequence }
    discount 10
    association(:source_product, factory: :product)
    association(:source_option, factory: :option)
    item_code '1234231-234'
    date_added { Date.today.iso8601 }
  end
end
