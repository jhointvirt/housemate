class JwtService
  def login(params)
    @user = User.find_by(email: params[:user][:email])
    unless @user
      return false 
    end

    @payload = {
      data: { email: @user.email, id: @user.id },
      exp: Time.now.to_i + Rails.application.credentials.dig(:jwt, :expire_access_in_seconds)
    }
    @access_token = generate_token(@payload)

    @payload[:exp] = @payload[:exp] + Rails.application.credentials.dig(:jwt, :expire_refresh_in_days).days
    @refresh_token = generate_token(@payload)
    @token = RefreshToken.find_by(user_id: @user.id)
    if @token
      @token.update(refresh_token: @refresh_token)
    else
      @user.create_refresh_token(refresh_token: @refresh_token)
    end

    return { access_token: @access_token, refresh_token: @refresh_token }
  end

  private
  
  def generate_token(payload)
    JWT.encode payload, Rails.application.credentials.dig(:jwt, :secret), 'HS256'
  end
end