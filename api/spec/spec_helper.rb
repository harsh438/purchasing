require File.join(File.dirname(__FILE__), 'support/rails')
require 'json'
require 'webmock/rspec'
require 'paperclip/matchers'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = false
  config.infer_spec_type_from_file_location!
  config.include Paperclip::Shoulda::Matchers

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 5
  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect

    mocks.verify_partial_doubles = true
  end

  config.before :example do
    ActionMailer::Base.deliveries.clear
  end
end
