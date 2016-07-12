class PvxIn < ActiveRecord::Base
  self.table_name = :pvx_in

  belongs_to :product, foreign_key: :pid
end
