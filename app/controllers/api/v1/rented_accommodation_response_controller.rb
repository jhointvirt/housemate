class Api::V1::RentedAccommodationResponseController < ApplicationController
  before_action :current_user
  def index
    render json: RentedAccommodationResponse.all, status: :ok
  end

  def show_by_current_user
    render json: current_profile.rented_accommodation_response, status: :ok
  end

  def create
    @rented_accommodation = RentedAccommodation.find(params[:rented_accommodation_response][:rented_accommodation_id])

    return render json: { message: 'Impossible on your own.' }, status: :bad_request if current_profile.id == @rented_accommodation[:profile_id]
    return render json: { message: 'You have already responded.' }, status: :bad_request unless RentedAccommodationResponse.find_by(profile_id: current_profile.id).blank?

    @created_rented_accommodation_response = RentedAccommodationResponse.new(rented_accommodation_response_params)
    @created_rented_accommodation_response.profile_id = current_profile.id
    @created_rented_accommodation_response.save

    if @created_rented_accommodation_response.errors.empty?
      render json: @created_rented_accommodation_response, status: :ok
    else
      render json: @created_rented_accommodation_response.errors, status: :bad_request
    end
  end

  private

  def rented_accommodation_response_params
    params.require(:rented_accommodation_response).permit(:message, :profile_id, :rented_accommodation_id)
  end
end
