require 'rails_helper'

RSpec.describe RentedAccommodationResponse, type: :model do
  before(:each) do
    @user = create_user_with_profile
    
    @rented_accommodation = RentedAccommodation.create(
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 80.0,
      latitude: 80.0,
      link: 'example.com',
      profile_id: @user.profile.id)
    
    @rented_accommodation_response = RentedAccommodationResponse.new(
      message: "Hello world",
      profile_id: @user.profile.id,
      rented_accommodation_id: @rented_accommodation.id
    )
  end

  it "is valid with valid attributes" do
    expect(@rented_accommodation_response).to be_valid
  end

  it "is not valid with nil profile id" do
    @rented_accommodation_response.profile_id = nil
    expect(@rented_accommodation_response).to_not be_valid
  end

  it "is not valid with nil rented accommodation id" do
    @rented_accommodation_response.rented_accommodation_id = nil
    expect(@rented_accommodation_response).to_not be_valid
  end
end
