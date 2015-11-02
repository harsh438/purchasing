module HttpAuth
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate if Rails.application.config.http_auth[:enabled]
  end

  def http_authenticate
    return if session[:all_good] == true

    authenticate_or_request_with_http_basic(t(:http_challenge)) do |username, password|
      if valid_credentials?(username, password)
        session[:all_good] = true
      else
        false
      end
    end
  end

  private

  def valid_credentials?(username, password)
    config = Rails.application.config.http_auth
    username == config[:username] and password == config[:password]
  end
end
