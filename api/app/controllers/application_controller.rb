class ApplicationController < ActionController::Base
  include HttpAuth
  
  protect_from_forgery with: :exception
  layout false

  def default_url_options
    if Rails.env.staging? or Rails.env.production?
      { protocol: 'https' }
    else
      {}
    end
  end
end
