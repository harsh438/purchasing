class ApplicationController < ActionController::Base
  include HttpAuth
  
  protect_from_forgery with: :exception
  layout false
end
