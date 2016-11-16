namespace :barcode do
  desc 'Remaps old_barcode -> new_barcode for a given sku'
  task :remap_barcode, [:sku_id, :old_barcode, :new_barcode] => :environment do |_t, args|
    sku_id, old_barcode, new_barcode = args.values_at(:sku_id, :old_barcode, :new_barcode)

    abort('No barcodes provided') unless old_barcode.present? && new_barcode.present?
    abort('The barcodes are the same') if old_barcode == new_barcode

    old_barcode_id = Barcode.find_by(sku_id: sku_id).id
    new_barcode_exists = Barcode.where(barcode: new_barcode).exists?
    old_barcode_exists = Barcode.where(barcode: old_barcode).exists?
    sku_has_old_barcode = Barcode.where(sku_id: sku_id, barcode: old_barcode).exists?

    abort('new_barcode already exists') if new_barcode_exists
    abort('old_barcode doesn\'t exist') unless old_barcode_exists
    abort('No barcode with that sku found') unless sku_has_old_barcode

    Barcode::Updater.update(barcode: new_barcode, id: old_barcode_id)
    Sku.find_by(id: sku_id).touch
  end
end
