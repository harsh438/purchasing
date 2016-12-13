class CreateBatchFileLines < ActiveRecord::Migration
  def change
    create_table :batch_file_lines do |t|
      t.integer :batch_file_id
      t.text    :contents
      t.string  :status
      t.text    :processor_errors
      t.timestamps null: false
    end
  end
end
