ENV['SINATRA_ENV'] ||= 'development'

require 'capybara/dsl'
require 'rspec'
require 'sinatra'
require_relative '../app/application'

disable :run

Capybara.app = Purchasing::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end
