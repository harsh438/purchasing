class ProductDetail < ActiveRecord::Base
  include LegacyMappings
  self.table_name = :sd_product_details
  map_attributes id: :pID,
                 closing_date: :closingDate,
                 planned_weeks_on_sale: :plannedWeeksOnSale

end
