class SessionsController < AuthorizedController
  authenticate! :example

  # POST /sessions/new
  def create
    session[:state] = SecureRandom.hex(8)
    session[:state_created_at] = Time.zone.now.utc.iso8601
    redirect_to client.auth_code.authorize_url(
      redirect_uri: callback_sessions_url,
      state: session[:state]
    )
  end

  # GET /sessions/callback
  def callback
    if valid_state? && valid_timeframe?
      reset_session
      create_token(params[:code])
      # valid callback and now with a token so let's send the user on
      redirect_to session.fetch(:jump, example_sessions_path) and return
    end
    # would usually indicate that signin failed with a flash message
    # but I'm lazy here
    redirect_to new_session_path
  end

  private

  def create_token(code)
    client.auth_code.get_token(code, redirect_uri: callback_sessions_url).tap do |tok|
      session[:token_params] = tok.to_hash
    end
  end

  def valid_state?
    params[:state] == session[:state]
  end

  def valid_timeframe?
    created_at = Time.zone.parse(session[:state_created_at])
    created_at += 5.minutes
    return created_at > Time.zone.now
  end
end
