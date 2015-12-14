desc 'Migrate legacy products to SKUs table'
namespace :legacy do
  task migrate: :environment do
    ProductMigrator.new.migrate
  end
end
