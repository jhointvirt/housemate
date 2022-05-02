require 'rails_helper'

RSpec.describe "Api::V1::RentedAccommodationResponses", type: :request do
  it "returns status 200 when get all (index)" do
    @rented_accommodation_first = generate_rented_accommodation
    @rented_accommodation_second = generate_rented_accommodation
    @first_user = create_user_with_profile
    @second_user = create_user_with_profile
    generate_rented_accommodation_response(@first_user.profile.id, @rented_accommodation_first.id)
    generate_rented_accommodation_response(@first_user.profile.id, @rented_accommodation_first.id)
    generate_rented_accommodation_response(@second_user.profile.id, @rented_accommodation_first.id)

    @all = RentedAccommodationResponse.all
    @headers = { "Authorization": "Bearer " + get_access_token(@first_user) }

    get '/api/v1/rented_accommodation_response', :headers => @headers
    expect(response.status).to eq(200)
    expect(response.body).to eq(@all.to_json)
    expect(3).to eq(@all.length)
  end

  it "returns status 200 when get show by current profile" do
    @rented_accommodation_first = generate_rented_accommodation
    @rented_accommodation_second = generate_rented_accommodation
    @first_user = create_user_with_profile
    @second_user = create_user_with_profile
    
    generate_rented_accommodation_response(@first_user.profile.id, @rented_accommodation_first.id)
    generate_rented_accommodation_response(@first_user.profile.id, @rented_accommodation_first.id)
    generate_rented_accommodation_response(@second_user.profile.id, @rented_accommodation_first.id)

    @all = @first_user.profile.rented_accommodation_response
    @headers = { "Authorization": "Bearer " + get_access_token(@first_user) }

    get '/api/v1/rented_accommodation_response/show_my_responses', :headers => @headers
    expect(response.status).to eq(200)
    expect(response.body).to eq(@all.to_json)
    expect(2).to eq(@all.length)
  end

  it 'returns status 401 when create' do
    post '/api/v1/rented_accommodation_response/', :headers => nil, :params => { rented_accommodation_response: {} }
    expect(response.status).to eq(401)
  end

  it 'returns status 400 when create with message Impossible on your own' do
    @rented_accommodation = generate_rented_accommodation
    profile_id = @rented_accommodation.profile_id
    @user = User.find(Profile.find(profile_id).user_id)

    @headers = { "Authorization": "Bearer " + get_access_token(@user) }

    post '/api/v1/rented_accommodation_response/', :headers => @headers, :params => { rented_accommodation_response: {
      rented_accommodation_id: @rented_accommodation.id
    }}
    expect(response.status).to eq(400)
    @body = JSON.parse(response.body)
    expect(@body['message']).to eq('Impossible on your own.')
  end

  it 'returns status 400 when create with message You have already responded.' do
    @rented_accommodation = generate_rented_accommodation
    @user = create_user_with_profile

    @headers = { "Authorization": "Bearer " + get_access_token(@user) }

    post '/api/v1/rented_accommodation_response/', :headers => @headers, :params => { rented_accommodation_response: {
      rented_accommodation_id: @rented_accommodation.id
    }}
    expect(response.status).to eq(200)
    post '/api/v1/rented_accommodation_response/', :headers => @headers, :params => { rented_accommodation_response: {
      rented_accommodation_id: @rented_accommodation.id
    }}
    expect(response.status).to eq(400)
    @body = JSON.parse(response.body)
    expect(@body['message']).to eq('You have already responded.')
  end

  it 'returns status 200 when create' do
    @rented_accommodation = generate_rented_accommodation
    @user = create_user_with_profile

    @headers = { "Authorization": "Bearer " + get_access_token(@user) }

    post '/api/v1/rented_accommodation_response/', :headers => @headers, :params => { rented_accommodation_response: {
      rented_accommodation_id: @rented_accommodation.id
    }}
    expect(response.status).to eq(200)
  end

  it 'returns status 200 when get responses on my accommodation' do
    @rented_accommodation = generate_rented_accommodation
    @user = create_user_with_profile

    @headers = { "Authorization": "Bearer " + get_access_token(@user) }

    get '/api/v1/rented_accommodation_response/get_responses_on_my_accommodation', :headers => @headers, :params => { rented_accommodation_response: {
      rented_accommodation_id: @rented_accommodation.id
    }}
    expect(response.status).to eq(200)
  end

  it 'returns status 401 when get responses on my accommodation' do
    get '/api/v1/rented_accommodation_response/get_responses_on_my_accommodation', :headers => nil, :params => { rented_accommodation_response: {} }
    expect(response.status).to eq(401)
  end

  private 

  def generate_rented_accommodation_response(profile_id, rented_accommodation_id)
    RentedAccommodationResponse.create(
      message: "First",
      profile_id: profile_id,
      rented_accommodation_id: rented_accommodation_id
    )
  end
end
