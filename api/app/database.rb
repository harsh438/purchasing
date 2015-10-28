require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  username: ENV['DATABASE_USER'],
  password: ENV['DATABASE_PASSWORD'],
  database: "#{ENV['DATABASE_NAME_PREFIX']}_#{Sinatra::Application.environment}"
)
