class JwtService
  def login(params)
    @user = User.find_by(email: params[:user][:email])
    unless @user
      return false 
    end

    @tokens = generate_refresh_and_access_tokens(get_payload(@user.email, @user.id))
    @token = RefreshToken.find_by(user_id: @user.id)
    if @token
      @token.update(refresh_token: @tokens[:refresh_token])
    else
      @user.create_refresh_token(refresh_token: @tokens[:refresh_token])
    end

    @tokens
  end

  def refresh(params)
    begin
      @decoded_refresh_token = JWT.decode(params[:tokens][:refresh_token], Rails.application.credentials.dig(:jwt, :secret), 'HS256')[0]
      @token = RefreshToken.find_by(user_id: @decoded_refresh_token['data']['id'])
      unless @token
        return { not_refresh?: true, message: 'Token not found in DB' }
      end
      unless @token[:refresh_token] == params[:tokens][:refresh_token]
        return { not_refresh?: true, message: 'Token already updated' } 
      end

      @expire_token = Time.at(@decoded_refresh_token['exp'].to_i)
      if @expire_token > Time.now
        @tokens = generate_refresh_and_access_tokens(get_payload(@decoded_refresh_token['data']['email'], @decoded_refresh_token['data']['id']))
        @token.update(refresh_token: @tokens[:refresh_token]) 
      else
        return { not_refresh?: true, message: 'Unable to update, refresh token expired' }
      end

      @tokens
    rescue JWT::VerificationError => e
      { not_refresh?: true, message: 'Verification error' }
    end
  end

  private

  def generate_refresh_and_access_tokens(payload)
    @access_token = generate_token(payload)
    payload[:exp] = payload[:exp] + Rails.application.credentials.dig(:jwt, :expire_refresh_in_days).days
    @refresh_token = generate_token(payload)
    { access_token: @access_token, refresh_token: @refresh_token }
  end

  def get_payload(email, id)
    { data: { email: email, id: id }, exp: Time.now.to_i + Rails.application.credentials.dig(:jwt, :expire_access_in_seconds) }
  end

  def generate_token(payload)
    JWT.encode(payload, Rails.application.credentials.dig(:jwt, :secret), 'HS256')
  end
end