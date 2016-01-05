ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../config/environment', __FILE__)
require 'rspec/rails'
include ActionDispatch::TestProcess

ActiveRecord::Migration.maintain_test_schema!
