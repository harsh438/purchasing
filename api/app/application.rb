require 'dotenv'
Dotenv.load
ENV['SINATRA_ENV'] ||= 'development'

require 'sinatra'
require 'sinatra/activerecord'

module Purchasing
  class Application < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    self.environment = ENV['SINATRA_ENV']

    set :database, adapter: 'mysql2',
                   username: ENV['DATABASE_USERNAME'],
                   password: ENV['DATABASE_PASSWORD'],
                   database: "#{ENV['DATABASE_NAME_PREFIX']}_#{ENV['SINATRA_ENV']}"

    set :root, File.dirname(__FILE__) + '/../'

    get '/' do
      File.read(File.join('public', 'index.html'))
    end

    get '/api/purchase_orders.json' do
      require_relative 'models/purchase_order'
      content_type :json
      PurchaseOrder.first(5).to_json
    end
  end
end
