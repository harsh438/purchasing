class AddSentInPeoplevoxToVendors < ActiveRecord::Migration
  def change
    add_column :ds_vendors, :sent_in_peoplevox, :datetime
  end
end
