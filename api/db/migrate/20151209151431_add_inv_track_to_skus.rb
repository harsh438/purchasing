class AddInvTrackToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :inv_track, :string
  end
end
