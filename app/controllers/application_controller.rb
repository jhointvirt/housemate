class ApplicationController < ActionController::API
  def current_user
    begin
      unless request.headers[:Authorization]
        return render json: { exception: "Unauthorized" }, status: :unauthorized
      end

      @token = request.headers[:Authorization].split(" ")[1]
      @data = JWT.decode(@token, Rails.application.credentials.dig(:jwt, :secret), 'HS256')[0]
      if @data
        User.find(@data['data']['id'].to_i)
      end
    rescue JWT::ExpiredSignature => exception
      return render json: { exception: exception }, status: :unauthorized
    end
  end

  def current_profile
    current_user.profile if current_user
  end
end
