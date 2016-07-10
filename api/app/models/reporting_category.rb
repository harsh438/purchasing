class ReportingCategory < ActiveRecord::Base
  self.table_name = :reporting_categories

  belongs_to :product, foreign_key: :pid
  belongs_to :category, foreign_key: :catid
end
