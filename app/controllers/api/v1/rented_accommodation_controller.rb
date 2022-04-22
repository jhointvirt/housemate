class Api::V1::RentedAccommodationController < ApplicationController
  before_action :current_user

  def create
    @rented_accommodation = RentedAccommodation.new(rented_accommodation_params)
    @rented_accommodation.profile_id = current_profile.id
    @rented_accommodation.save

    if @rented_accommodation.errors.empty?
      render json: @rented_accommodation, status: :ok
    else
      render json: @rented_accommodation.errors, status: :bad_request
    end
  end

  def update
    @rented_accommodation = RentedAccommodation.find(params[:id])
    unless @rented_accommodation[:profile_id] != current_profile.id
      return render json: { message: "You don't have a permission" }, status: :forbidden
    end

    @result = @rented_accommodation.update(rented_accommodation_params)
    if @result
      render json: @result, status: :ok
    else
      render json: @result, status: :bad_request
    end
  end

  private

  def rented_accommodation_params
    params.require(:rented_accommodation).permit(:title, :description, :address, :cost, :longitude, :latitude, :profile_id)
  end
end
