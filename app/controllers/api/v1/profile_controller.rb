class Api::V1::ProfileController < ApplicationController
  before_action :current_user

  def show_by_current_user
    render json: Profile.find_by(user_id: current_user.id), status: :ok
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile[:user_id] != current_user.id
      return render json: { message: "You don't have a permission" }, status: :forbidden
    end

    @result = Profile.update(profile_params)
    if @result
      render json: @result, status: 200
    else
      render json: @result, status: 400
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :gender, :birthday_date, :description)
  end
end
