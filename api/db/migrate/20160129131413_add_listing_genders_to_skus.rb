class AddListingGendersToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :listing_genders, :string
  end
end
