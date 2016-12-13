FactoryGirl.define do
  factory :batch_file_processor do
    processor_type 'BatchFiles::Processors::UpdatePurchaseOrderCostPriceBySku'
    csv_header_row 'po,sku,cost_price'
  end
end
