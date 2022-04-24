class Api::V1::UsersController < ApplicationController
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user
      return render json: params[:user][:email], status: :bad_request
    end

    @created_user = User.create(user_params)
    @created_user.create_profile(
      first_name: Faker::Name.first_name + ' - EXAMPLE',
      last_name: Faker::Name.last_name + '  - EXAMPLE',
      birthday_date: Date.today,
      gender: true)
    
    SendRegisterEmailJob.perform_later(@created_user.email)

    if @created_user.errors.empty?
      render json: @created_user, status: :ok
    else
      render json: @created_user.errors, status: :bad_request
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
