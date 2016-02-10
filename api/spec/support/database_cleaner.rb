require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before :example do
    DatabaseCleaner.clean
  end
end
