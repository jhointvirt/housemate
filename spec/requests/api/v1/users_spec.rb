require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  it "returns user and 200 status code" do
    user = { user: { email: Faker::Internet.email, password: 'StrongPass' } }
    post '/api/v1/users', :params => user
    expect(response.status).to eq(200)
  end

  it "returns conflict" do
    user = { user: { email: 'example@example.com', password: 'StrongPass' } }
    User.create(email: 'example@example.com', password: 'StrongPass')
    post '/api/v1/users', :params => user
    expect(response.status).to eq(409)
  end
end
