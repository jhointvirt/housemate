require 'rails_helper'

RSpec.describe RentedAccommodation, type: :model do
  before(:each) do
    @user = create_user_with_profile
    
    @rented_accommodation = RentedAccommodation.new(
      title: 'Random title',
      description: 'Random description',
      address: 'Address',
      cost: 400.0,
      longitude: 80.0,
      latitude: 80.0,
      link: 'example.com',
      profile_id: @user.profile.id)
  end

  it "is valid with valid attributes" do
    expect(@rented_accommodation).to be_valid
  end

  it "is not valid with nullable title" do
    @rented_accommodation.title = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with nullable description" do
    @rented_accommodation.description = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with nullable address" do
    @rented_accommodation.address = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with nullable cost" do
    @rented_accommodation.cost = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with different type of cost" do
    @rented_accommodation.cost = 'not number'
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with nullable longitude" do
    @rented_accommodation.longitude = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with nullable link" do
    @rented_accommodation.link = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with different of longitude" do
    @rented_accommodation.longitude = 'not number'
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with longitude less than -180" do
    @rented_accommodation.longitude = -181.0
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with longitude more than 180" do
    @rented_accommodation.longitude = 181.0
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with nullable latitude" do
    @rented_accommodation.latitude = nil
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with different of latitude" do
    @rented_accommodation.latitude = 'not number'
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with latitude less than -90" do
    @rented_accommodation.latitude = -91.0
    expect(@rented_accommodation).to_not be_valid
  end

  it "is not valid with latitude more than 90" do
    @rented_accommodation.latitude = 91.0
    expect(@rented_accommodation).to_not be_valid
  end
end
