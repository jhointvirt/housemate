class Api::V1::ProfileController < ApplicationController
  before_action :current_user

  def show_by_current_user
    render json: Profile.find_by(user_id: current_user.id), status: :ok
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile != current_profile
      return render json: { message: 'Access denied' }, status: :forbidden
    end

    @result = @profile.update(profile_params)
    if @result
      render json: @result, status: :ok
    else
      render json: @result, status: :bad_request
    end
  end

  def update_avatar
    @profile = Profile.find(params[:id])
    if @profile != current_profile
      return render json: { message: 'Access denied' }, status: :forbidden
    end

    @result = @profile.update(avatar: params[:avatar])
    if @result
      render json: @result, status: :ok
    else
      render json: @result, status: :bad_request
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :gender, :birthday_date, :description, :avatar)
  end
end
