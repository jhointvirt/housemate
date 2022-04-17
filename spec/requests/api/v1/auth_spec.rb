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
  end
end
