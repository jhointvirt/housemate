class ApplicationController < ActionController::API
  def current_user
    begin
      unless request.headers[:Authorization]
        return render json: { exception: "unautorized" }, status: 401
      end

      @token = request.headers[:Authorization].split(" ")[1]
      @data = JWT.decode(@token, Rails.application.credentials.dig(:jwt, :secret), 'HS256')[0]
      if @data
        User.find(@data['data']['id'].to_i)
      end
    rescue JWT::ExpiredSignature => exception
      render json: { exception: exception }, status: :not_found
    end
  end
end
