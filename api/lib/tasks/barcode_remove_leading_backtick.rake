namespace :barcode do
  desc "remove leading backticks from barcode"
  task :backtick_fix => :environment do
    old_barcodes = Barcode.where('barcode LIKE ?', "'%")
    puts "#{old_barcodes.length} Barcodes found"
    abort("There are no barcodes that need fixing") if old_barcodes.empty?
    old_barcodes.each{ | barcode |
      new_barcode = barcode.barcode[1..-1]
      Barcode::Updater.update(barcode: new_barcode, id: barcode.id)
    }
    puts "#{old_barcodes.length} Barcodes fixed"
  end
end
