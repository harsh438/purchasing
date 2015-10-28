require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  username: 'root',
  password: 'root',
  database: 'purchasing'
)