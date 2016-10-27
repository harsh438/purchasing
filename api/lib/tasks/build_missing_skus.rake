namespace :sku do
  desc 'Adds missing rows to the sku database'
  task :build_sku, [:missing_sku_id] => :environment do |_t, args|
    missing_sku_id = args[:missing_sku_id]

    unsized_attrs = Sku::UnsizedMissingAttributes.new(missing_sku_id)
    sized_attrs   = Sku::SizedMissingAttributes.new(unsized_attrs)

    begin
      Sku::Maker.new(unsized_attrs: unsized_attrs, sized_attrs: sized_attrs)
        .create_or_update_references
    rescue ArgumentError
      puts "#{missing_sku_id} is not missing!"
    end
  end
end
