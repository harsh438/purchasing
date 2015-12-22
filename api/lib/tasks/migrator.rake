desc 'Migrate legacy products to SKUs table'
namespace :legacy do
  task migrate: :environment do
    Product::Migrator.new.migrate
  end
end
