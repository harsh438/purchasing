namespace :order_fix do
  desc "Checks for and deletes skus and orders that are missing data"
  task :delete_problem_data, [:OT_number] => :environment do |_t, args|
    ot_number = args[:OT_number]
    abort("No order tool id number given") unless ot_number
    skus = Sku.po_by_operator(ot_number)
    abort("There were no skus found") if skus.count < 1
    skus.each(&:destroy)
    orders = Order.order_by_ot_number(ot_number)
    order_line_items = OrderLineItem.by_ot_number(ot_number)
    order_line_items.each(&:destroy) if (order_line_items.length > 0)
    orders.each(&:destroy) if (orders.length > 0)
    po_numbers = PurchaseOrderLineItem.po_by_operator(ot_number)
    po_numbers.each { | po_number | puts po_number }
  end

  desc "Deletes an old po, but keeps the po number and puts it onto a different given po."
  task :remap_po, [:po_number_being_kept, :po_number_being_changed] => :environment do |_t, args|
    po1 = args[:po_number_being_kept]
    po2 = args[:po_number_being_changed]
    abort("We need the POs") unless po1 && po2
    abort("The POs are the same") if po1 == po2
    PurchaseOrderLineItem.by_po_number(po1).each(&:destroy)
    PurchaseOrderLineItem.move_old_po_number_across(po1, po2)
    PurchaseOrder.destroy_all(po_num: po2)
  end
end
