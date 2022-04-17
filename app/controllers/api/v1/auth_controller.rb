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
end
