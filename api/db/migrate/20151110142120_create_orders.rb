class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status, index: true, default: 'new'
      t.timestamps
    end
  end
end
