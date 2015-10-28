require 'capybara/dsl'
require 'rspec'
require 'sinatra'
require_relative '../app/application'

Sinatra::Application.environment = :test
disable :run

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end
