FactoryGirl.define do
  factory :merge_job do
    from_sku_id 1
    to_sku_id 2
    from_internal_sku '123-4'
    to_internal_sku '1234-5'
    from_sku_size 'l'
    to_sku_size 'L'
    barcode '1234567'
    completed_at nil

    trait :completed do
      completed_at Time.current
    end
  end
end
