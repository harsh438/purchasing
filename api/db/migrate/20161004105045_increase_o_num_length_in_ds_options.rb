class IncreaseONumLengthInDsOptions < ActiveRecord::Migration
  def up
    change_column :ds_options, :oNum, :string, :limit => 255
  end

  def down
    change_column :ds_options, :oNum, :string, :limit => 40
  end
end
