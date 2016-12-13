class CreateCostPriceLog < ActiveRecord::Migration
  def change
    create_table :cost_price_logs do |t|
      t.integer :purchase_order_number
      t.integer :product_id
      t.string :sku
      t.integer :quantity
      t.decimal :before_cost, precision: 8, scale: 2
      t.decimal :after_cost, precision: 8, scale: 2
      t.timestamps null: false
    end
  end
end
