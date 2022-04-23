class Api::V1::MapController < ApplicationController
  attr_accessor :map
  def initialize
    super
    @map = OpenStreetMap::Client.new
  end

  def show_by_place_name
    render json: map.search(q: params[:q], format: 'json', addressdetails: '1', accept_language: 'en'), status: :ok
  end

  def reverse_place_from_coordinate
    render json: map.reverse(format: 'json', lat: params[:latitude], lon: params[:longitude], accept_language: 'en'), status: :ok
  end
end
