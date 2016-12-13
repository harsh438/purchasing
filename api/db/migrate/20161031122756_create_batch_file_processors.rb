class CreateBatchFileProcessors < ActiveRecord::Migration
  def change
    create_table :batch_file_processors do |t|
      t.string  :processor_type, unique: true
      t.string  :csv_header_row
      t.boolean :available
    end
  end
end
