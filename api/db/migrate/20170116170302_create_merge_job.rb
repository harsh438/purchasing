class CreateMergeJob < ActiveRecord::Migration
  def change
    create_table :merge_jobs do |t|
      t.integer :from_sku_id
      t.string :from_internal_sku
      t.string :from_sku_size
      t.integer :to_sku_id
      t.string :to_internal_sku
      t.string :to_sku_size
      t.string :barcode
      t.datetime :completed_at
      t.timestamps
    end
  end
end
