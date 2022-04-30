require 'rails_helper'

RSpec.describe "Api::V1::RentedAccommodationResponses", type: :request do
  it "returns status 200 when get all (index)" do
    @rented_accommodation_first = generate_rented_accommodation
    @rented_accommodation_second = generate_rented_accommodation
    @first_user = create_user_with_profile
    @second_user = create_user_with_profile
    RentedAccommodationResponse.create(
      message: "First",
      profile_id: @first_user.profile.id,
      rented_accommodation_id: @rented_accommodation_first.id
    )

    RentedAccommodationResponse.create(
      message: "Second",
      profile_id: @first_user.profile.id,
      rented_accommodation_id: @rented_accommodation_second.id
    )

    RentedAccommodationResponse.create(
      message: "Third",
      profile_id: @second_user.profile.id,
      rented_accommodation_id: @rented_accommodation_second.id
    )

    @all = RentedAccommodationResponse.all
    @headers = { "Authorization": "Bearer " + get_access_token(@first_user) }

    get '/api/v1/rented_accommodation_response', :headers => @headers
    expect(response.status).to eq(200)
    expect(response.body).to eq(@all.to_json)
  end

  it "returns status 200 when get show by current profile" do
    @rented_accommodation_first = generate_rented_accommodation
    @rented_accommodation_second = generate_rented_accommodation
    @first_user = create_user_with_profile
    @second_user = create_user_with_profile

    RentedAccommodationResponse.create(
      message: "First",
      profile_id: @first_user.profile.id,
      rented_accommodation_id: @rented_accommodation_first.id
    )

    RentedAccommodationResponse.create(
      message: "Second",
      profile_id: @first_user.profile.id,
      rented_accommodation_id: @rented_accommodation_second.id
    )

    RentedAccommodationResponse.create(
      message: "Third",
      profile_id: @second_user.profile.id,
      rented_accommodation_id: @rented_accommodation_second.id
    )

    @all = @first_user.profile.rented_accommodation_response
    @headers = { "Authorization": "Bearer " + get_access_token(@first_user) }

    get '/api/v1/rented_accommodation_response/show_by_current_user', :headers => @headers
    expect(response.status).to eq(200)
    expect(response.body).to eq(@all.to_json)
  end
end
