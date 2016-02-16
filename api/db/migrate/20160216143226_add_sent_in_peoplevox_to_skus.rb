class AddSentInPeoplevoxToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :sent_in_peoplevox, :datetime
  end
end
