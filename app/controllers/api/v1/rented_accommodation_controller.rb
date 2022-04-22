class Api::V1::RentedAccommodationController < ApplicationController
  before_action :current_user

  def create
    @rented_accommodation = rented_accommodation_params
    @rented_accommodation[:profile_id] = current_profile.user_id
    
    @rented_accommodation = RentedAccommodation.create(@rented_accommodation)

    if @rented_accommodation.errors.empty?
      render json: @rented_accommodation, status: :ok
    else
      render json: @rented_accommodation.errors, status: :conflict
    end
  end

  private

  def rented_accommodation_params
    params.require(:rented_accommodation).permit(:title, :description, :address, :cost, :longitude, :latitude, :profile_id)
  end
end
