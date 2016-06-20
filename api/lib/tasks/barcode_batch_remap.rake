namespace :barcode do
  desc "Takes a CSV file as input to run barcode:remap_barcode. Don't put in dup values."
  task :remap_barcode_csv, [:csv_file] => :environment do |t, args|
    require 'csv'
    csv_file = args[:csv_file]
    CSV.open(File.expand_path(csv_file)) do | rows |
      rows.each do | row |
        begin
          Rake::Task["barcode:remap_barcode"].reenable
          Rake::Task["barcode:remap_barcode"].invoke(row[0].to_s,row[1].to_s,row[2].to_s)
        rescue SystemExit
          puts "#{row} failed"
        end
      end
    end
  end
end
