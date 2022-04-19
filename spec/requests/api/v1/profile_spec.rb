require 'rails_helper'
require 'helpers/controller_helpers'

RSpec.describe "Api::V1::Profiles", type: :request do
  it "returns status 200 when login" do
    @headers = { "Authorization": "Bearer " + get_access_token(create_user_with_profile) }
    get '/api/v1/profile/show_by_current_user', :headers => @headers
    expect(response.status).to eq(200)
  end

  it "returns status 401 unautorized" do
    get '/api/v1/profile/show_by_current_user'
    expect(response.status).to eq(401)
  end

  it "returns status 401 unautorized" do
    put '/api/v1/profile/:id', :params => { id: 1 }
    expect(response.status).to eq(401)
  end

  it "returns status 403 unautorized" do
    @headers = { "Authorization": "Bearer " + get_access_token(create_user_with_profile) }
    @profile = Profile.find_by(user_id: create_and_get_current_user_with_access_token[:user][:id])
    put '/api/v1/profile/' + @profile[:id].to_s, :headers => @headers
    expect(response.status).to eq(403)
    @body = JSON.parse(response.body)
    expect(@body['message']).to eq("You don't have a permission")
  end

  it "returns status 200" do
    @user = create_and_get_current_user_with_access_token
    @headers = { "Authorization": "Bearer " + @user[:token] }
    @profile = Profile.find_by(user_id: @user[:user][:id].to_i)
    put '/api/v1/profile/' + @profile[:id].to_s, :headers => @headers, :params => { profile: { 
                                                                                  first_name: Faker::Name.first_name + ' - EXAMPLE',
                                                                                  last_name: Faker::Name.last_name + '  - EXAMPLE',
                                                                                  birthday_date: Date.today,
                                                                                  gender: true }  }
    expect(response.status).to eq(200)
  end

  it "returns status 400" do
    @user = create_and_get_current_user_with_access_token
    @headers = { "Authorization": "Bearer " + @user[:token] }
    @profile = Profile.find_by(user_id: @user[:user][:id].to_i)
    put '/api/v1/profile/' + @profile[:id].to_s, :headers => @headers, :params => { profile: { 
                                                                                  first_name: Faker::Name.first_name + ' - EXAMPLE',
                                                                                  last_name: Faker::Name.last_name + '  - EXAMPLE',
                                                                                  birthday_date: nil,
                                                                                  gender: true }  }
    expect(response.status).to eq(200)
  end
end
