class Api::V1::UsersController < ApplicationController
  def create
    user = User.find_by(email: params[:user][:email])
    if user
      return render json: params[:user][:email], status: :conflict
    end

    render json: User.create(user_params), status: :ok
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
