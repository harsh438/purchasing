class Product < ActiveRecord::Base
  self.table_name = :ds_products
  #alias_attribute :pID, :id
  #default_scope -> { select('pID as id, pNum as name') }
end
