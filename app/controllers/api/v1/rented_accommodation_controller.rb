class Api::V1::RentedAccommodationController < ApplicationController
  before_action :current_user, except: [:index, :show, :new]
  attr_accessor :map

  def initialize
    super
    @map = OpenStreetMap::Client.new
  end

  def index
    render json: RentedAccommodationFilter.new(nil, params).execute, status: :ok
  end
  
  def new
    @details_information = map.reverse(format: 'json', lat: params[:latitude], lon: params[:longitude], accept_language: 'en')

    return render json: RentedAccommodation.new if @details_information['error'] || !@details_information
    
    render json: RentedAccommodation.new(
      address: @details_information['display_name'],
      latitude: @details_information['lat'],
      longitude: @details_information['lon'],
      house_number: @details_information['address']['house_number'],
      city: @details_information['address']['city'],
      country: @details_information['address']['country'],
      country_code: @details_information['address']['country_code']
    )
  end

  def show
    render json: RentedAccommodation.find(params[:id]), status: :ok
  end

  def create
    @rented_accommodation = RentedAccommodation.new(rented_accommodation_params)
    @rented_accommodation.profile_id = current_profile.id
    @rented_accommodation.save

    if @rented_accommodation.errors.empty?
      p RentedAccommodation.find(@rented_accommodation.id).photos_attachments
      render json: @rented_accommodation, status: :ok
    else
      render json: @rented_accommodation.errors, status: :bad_request
    end
  end

  def update
    @rented_accommodation = RentedAccommodation.find(params[:id])
    unless @rented_accommodation[:profile_id] != current_profile.id
      return render json: { message: 'Access denied' }, status: :forbidden
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
    params.require(:rented_accommodation).permit(:title, :description, :address, :cost, :longitude, :latitude, :house_number, :city, :country, :country_code, :link, :profile_id, photos: [])
  end
end