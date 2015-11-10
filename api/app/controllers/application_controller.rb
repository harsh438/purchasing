class ApplicationController < ActionController::Base
  include HttpAuth

  skip_before_action :verify_authenticity_token

  layout false

  def default_url_options
    if Rails.env.staging? or Rails.env.production?
      { protocol: 'https' }
    else
      {}
    end
  end
end
