class Api::V1::AuthController < ApplicationController
  def initialize 
    super
    @jwt_service = JwtService.new
  end

  def login
    tokens = @jwt_service.login(params)
    unless tokens
      return render json: params[:user][:email], status: :not_found
    end

    render json: tokens, status: :ok
  end

  def refresh
    @tokens = @jwt_service.refresh(params)

    if @tokens[:not_refresh?]
      return render json: { refresh_token: params[:tokens][:refresh_token], message: @tokens[:message] }, status: :conflict
    end

    render json: @tokens, status: :ok
  end
end
