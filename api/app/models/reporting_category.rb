class ReportingCategory < ActiveRecord::Base
  self.table_name = :reporting_categories

  include LegacyMappings

  map_attributes category_id: :catid

  belongs_to :product, foreign_key: :pid
  belongs_to :category, foreign_key: :catid
end
