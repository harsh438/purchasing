class AddUpdatedAtToDsProducts < ActiveRecord::Migration
  def change
    add_column :ds_products, :updated_at, :datetime
  end
end
