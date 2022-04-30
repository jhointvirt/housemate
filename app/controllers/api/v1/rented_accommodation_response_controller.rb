class Api::V1::RentedAccommodationResponseController < ApplicationController
  before_action :current_user
  def index
    render json: RentedAccommodationResponse.all, status: :ok
  end

  def show_by_current_user
    render json: current_profile.rented_accommodation_response, status: :ok
  end
end
