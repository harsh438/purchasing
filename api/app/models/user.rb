class User < ActiveRecord::Base
  self.table_name = 'st_sduser'
  self.primary_key = 'userID'
end
