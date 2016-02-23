FactoryGirl.define do
  factory :purchase_order do
    drop_date { Time.now }
    vendor

    trait :with_line_items do
      line_items { build_list(:purchase_order_line_item, 4, vendor: vendor) }
    end

    trait :with_line_items_with_barcode do
      line_items { build_list(:purchase_order_line_item, 4, :with_barcode, vendor: vendor) }
    end

    trait :with_line_items_with_barcode_and_product do
      line_items { build_list(:purchase_order_line_item, 4, :with_barcode, :with_product, vendor: vendor) }
    end

    trait :with_line_items_sent_in_peoplevox do
      line_items { build_list(:purchase_order_line_item, 4, :sent_in_peoplevox, vendor: vendor) }
    end

    trait :with_balance_line_items do
      line_items { build_list(:purchase_order_line_item, 2, :balanced, vendor: vendor) }
    end

    trait :with_old_drop_date do
      drop_date { 1.year.ago }
    end

    trait :without_updated_date do
      updated_at nil
      record_timestamps false
    end

    trait :with_old_updated_date do
      updated_at 1.year.ago
      record_timestamps false
    end

    trait :with_fixed_updated_date do
      # does not matter which date it is as long as it's really old and the same
      updated_at Time.parse('1948-02-18T17:26:26')
      record_timestamps false
    end

    trait :with_recent_updated_date do
      updated_at 5.minutes.ago
      record_timestamps false
    end

    trait :with_grn_events do
      goods_received_notice_events { build_list(:goods_received_notice_event, 4, :for_today) }
    end
  end
end
