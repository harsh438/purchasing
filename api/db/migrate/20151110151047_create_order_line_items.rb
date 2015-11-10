class CreateOrderLineItems < ActiveRecord::Migration
  def change
    create_table :order_line_items do |t|
      t.string :internal_sku
      t.integer :quantity
      t.decimal :cost, precision: 8, scale: 2
      t.decimal :discount, precision: 8, scale: 4
      t.references :order, index: true, foreign_key: true
      t.timestamps
      t.datetime :drop_date
    end
  end
end
