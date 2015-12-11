class RemoveInvTrackFromSkus < ActiveRecord::Migration
  def change
    remove_column :skus, :inv_track
  end
end
