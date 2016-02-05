class CreatePackingLists < ActiveRecord::Migration
  def change
    create_table :packing_lists do |t|
      t.references :goods_received_notice, index: true
      t.attachment :list
      t.timestamps
    end
  end
end
