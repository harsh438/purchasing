module HttpAuth
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate if Rails.application.config.http_auth[:enabled]
  end

  def http_authenticate
    return if cookies.signed[:http_authed] == true

    authenticate_or_request_with_http_basic(t(:http_challenge)) do |username, password|
      if valid_credentials?(username, password)
        cookies.signed[:http_authed] = true
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
