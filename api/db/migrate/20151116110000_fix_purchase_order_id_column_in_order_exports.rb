class FixPurchaseOrderIdColumnInOrderExports < ActiveRecord::Migration
  def change
    begin
      remove_foreign_key :order_exports, { column: :purchase_order_id }
    rescue ArgumentError => e
      Rails.logger.info "Foreign key not found"
    end
  end
end
