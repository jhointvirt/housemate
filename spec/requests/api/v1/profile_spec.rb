require 'rails_helper'
require 'helpers/controller_helpers'

RSpec.describe "Api::V1::Profiles", type: :request do
  it "returns status 200 when login" do
    @headers = { "Authorization": "Bearer " + get_access_token(create_user_with_profile) }
    get '/api/v1/profile/show_by_current_user', :headers => @headers
    expect(response.status).to eq(200)
  end

  it "returns status 200 when update" do
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

  it "returns status 200 when show current user" do
    @user = create_and_get_current_user_with_access_token
    @headers = { "Authorization": "Bearer " + @user[:token] }
    get '/api/v1/profile/show_by_current_user', :headers => @headers
    expect(response.status).to eq(200)
    expect(response.body).to eq(@user[:user].profile.to_json)
  end

  it "returns status 401 when update" do
    put '/api/v1/profile/:id', :params => { id: 1 }
    expect(response.status).to eq(401)
  end

  it "returns status 403 when update" do
    @headers = { "Authorization": "Bearer " + get_access_token(create_user_with_profile) }
    @profile = create_and_get_current_user_with_access_token[:user].profile
    put '/api/v1/profile/' + @profile.id.to_s, :headers => @headers
    expect(response.status).to eq(403)
    @body = JSON.parse(response.body)
    expect(@body['message']).to eq("Access denied")
  end

  it "returns status 400 with invalid params when update" do
    @user = create_and_get_current_user_with_access_token
    @headers = { "Authorization": "Bearer " + @user[:token] }
    @profile = @user[:user].profile
    put '/api/v1/profile/' + @profile.id.to_s, :headers => @headers, :params => { profile: { 
                                                                                  first_name: Faker::Name.first_name + ' - EXAMPLE',
                                                                                  last_name: Faker::Name.last_name + '  - EXAMPLE',
                                                                                  birthday_date: nil,
                                                                                  gender: true }  }
    expect(response.status).to eq(400)
  end

  it "returns status 401 when update avatar" do
    put '/api/v1/profile/update_avatar/:id', :params => { id: 1 }
    expect(response.status).to eq(401)
  end

  it "returns status 403 when update avatar" do
    @headers = { "Authorization": "Bearer " + get_access_token(create_user_with_profile) }
    @profile = create_and_get_current_user_with_access_token[:user].profile
    put '/api/v1/profile/update_avatar/' + @profile.id.to_s, :headers => @headers
    expect(response.status).to eq(403)
    @body = JSON.parse(response.body)
    expect(@body['message']).to eq("Access denied")
  end

  it "returns status 200 when update" do
    @user = create_and_get_current_user_with_access_token
    @headers = { "Authorization": "Bearer " + @user[:token] }
    @profile = Profile.find_by(user_id: @user[:user][:id].to_i)
    put '/api/v1/profile/update_avatar/' + @profile[:id].to_s, :headers => @headers, :params => { avatar: Rack::Test::UploadedFile.new('spec/images/test.jpg', 'image/jpg') }
    expect(response.status).to eq(200)
  end
end
