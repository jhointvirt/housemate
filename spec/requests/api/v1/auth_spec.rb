require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  before(:all) do
    User.create(email: 'example@example.com', password: 'StrongPass')
  end

  it "returns tokens and 200 status code" do
    user = { user: { email: 'example@example.com', password: 'StrongPass' } }
    post '/api/v1/auth/login', :params => user
    expect(response.status).to eq(200)
  end

  it "returns email and 404 status code" do
    user = { user: { email: 'ex@ex.com', password: 'StrongPass' } }
    post '/api/v1/auth/login', :params => user
    expect(response.status).to eq(404)
    expect(response.body).to eq(user[:user][:email])
  end

  it "returns new tokens and 200 status code" do
    user = { user: { email: 'example@example.com', password: 'StrongPass' } }
    post '/api/v1/auth/login', :params => user
    expect(response.status).to eq(200)
    post '/api/v1/auth/refresh', :params => { tokens: JSON.parse(response.body) }
    expect(response.status).to eq(200)
  end

  it "returns refresh token and message and 409 status code" do
    user = { user: { email: 'example@example.com', password: 'StrongPass' } }
    post '/api/v1/auth/login', :params => user
    expect(response.status).to eq(200)

    body = JSON.parse(response.body)
    body['refresh_token'] = body['refresh_token'].to_s.chop
    post '/api/v1/auth/refresh', :params => { tokens: body }
    expect(response.status).to eq(409)

    body = JSON.parse(response.body)
    expect(body['message']).to eq('Verification error')
  end
end
