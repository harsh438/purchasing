FactoryGirl.define do
  factory :goods_received_notice do
    delivery_date { Date.today }
    units 0
    cartons 0
    pallets 0

    order
    user

    # must be set
    received 0
    checking 0
    checked 0
    processing 0
    processed 0
    received_at '0001-01-01'
    page_count 0
    units_received 0
    cartons_received 0

    transient do
      po_count 1
    end

    trait :give_or_take_2_weeks do
      delivery_date { rand(2.weeks.ago..2.weeks.from_now) }
    end

    trait :with_purchase_orders do
      after(:create) do |grn, evaluator|
        evaluator.po_count.times do
          grn.goods_received_notice_events << create(:goods_received_notice_event, delivery_date: grn.delivery_date)
        end
      end
    end

    trait :with_packing_list do
      legacy_attachments ',RHYTHM SD91467-P  91468-P_DELIVERYNOTE.pdf'
    end

    trait :with_multiple_packing_list_with_no_trailing_comma do
      legacy_attachments 'RHYTHM SD91467-P  91468-P_DELIVERYNOTE.pdf,second.pdf,third.pdf'
    end

    trait :with_multiple_packing_lists do
      legacy_attachments ',RHYTHM SD91467-P  91468-P_DELIVERYNOTE.pdf,second.pdf,third.pdf'
    end

    trait :with_packing_list_with_invalid_characters do
      legacy_attachments ',Strange#filename_with_commas,,inside.xlsx'
    end

    trait :with_both_packing_lists do
      legacy_attachments ',RHYTHM SD91467-P  91468-P_DELIVERYNOTE.pdf,second.pdf,third.pdf'
      packing_lists { build_list(:packing_list, 2) }
    end
  end
end
