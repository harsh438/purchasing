class CopyInvTrackToSkus < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Sku.joins(:product).update_all('skus.inv_track = ds_products.invTrack')
      end
    end
  end
end
