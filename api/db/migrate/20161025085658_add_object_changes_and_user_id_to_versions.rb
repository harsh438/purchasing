class AddObjectChangesAndUserIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :object_changes, :text
    add_column :versions, :user_id, :integer
  end
end
