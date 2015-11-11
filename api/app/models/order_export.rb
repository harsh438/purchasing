class OrderExport < ActiveRecord::Base
  belongs_to :order
  belongs_to :purchase_order
end
