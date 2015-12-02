class AddGenderToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :gender, :string
  end
end
