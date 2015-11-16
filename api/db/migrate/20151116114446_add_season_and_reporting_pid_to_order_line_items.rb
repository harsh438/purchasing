class AddSeasonAndReportingPidToOrderLineItems < ActiveRecord::Migration
  def change
    add_column :order_line_items, :season, :string
    add_column :order_line_items, :reporting_pid, :integer
  end
end
