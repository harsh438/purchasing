class ReportingCategory < ActiveRecord::Base
  belongs_to :product, foreign_key: :pid
  belongs_to :category, foreign_key: :catid
end
