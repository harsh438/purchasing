class CreateOrderExports < ActiveRecord::Migration
  def change
    create_table :order_exports do |t|
      t.references :order, index: true, foreign_key: true
      t.references :purchase_order, index: true, foreign_key: true
      t.timestamps
    end
  end
end
