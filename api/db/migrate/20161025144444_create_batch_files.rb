class CreateBatchFiles < ActiveRecord::Migration
  def change
    create_table :batch_files do |t|
      t.string :description
      t.boolean :validation_started, default: false
      t.integer :processor_type_id
      t.boolean :processing_started, default: false
      t.attachment :csv
      t.integer :created_by_id

      t.timestamps null: false
    end
  end
end
