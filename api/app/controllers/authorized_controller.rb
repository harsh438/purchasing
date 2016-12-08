class AuthorizedController < ActionController::Base
  layout "application"

  def self.authenticate!(*actions)
    before_filter :require_auth!, only: actions
  end

  private

  def require_auth!
    session[:jump] = request.fullpath
    refresh_token!
    # if we have no token then we must get authorization from the user
    redirect_to new_session_url and return unless token
    # clean the session up as this request is authorized
    session.delete(:jump)
  end

  def refresh_token!
    if token.try(:expired?)
      @_token = token.refresh!
      session[:token_params] = token.to_hash
    end
  rescue
    # unset the token as we failed to refresh it
    @_token = nil
  end

  def client
    @_client ||= OAuth2::Client.new(*client_config)
  end

  def token
    # by storing the token params in the session we can enable refresh tokens and get
    # auto renewing tokens which is pretty sweet although its disabled by default
    @_token ||= OAuth2::AccessToken.from_hash(client, session[:token_params]) if session[:token_params]
  end

  def client_config
    config = Rails.application.config.surfdome
    [config["consumer_key"], config["secret_key"], { site: config["host"] }]
  end
end
