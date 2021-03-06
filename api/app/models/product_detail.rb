class ProductDetail < ActiveRecord::Base
  self.table_name = :sd_product_details

  include LegacyMappings

  map_attributes id: :pID,
                 color: :colour,
                 gender: :leadGender,
                 closing_date: :closingDate,
                 planned_weeks_on_sale: :plannedWeeksOnSale,
                 supplier_style_code: :brandProductCode,
                 supplier_color_code: :brandColourCode,
                 supplier_product_name: :brandProductName,
                 supplier_color_name: :brandColourName
end
