require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  it "returns user and 200 when create" do
    user = { user: { email: Faker::Internet.email, password: 'StrongPass' } }
    post '/api/v1/users', :params => user
    expect(response.status).to eq(200)
  end

  it "returns bad request when create" do
    user = { user: { email: 'example@example.com', password: 'StrongPass' } }
    User.create(email: 'example@example.com', password: 'StrongPass')
    post '/api/v1/users', :params => user
    expect(response.status).to eq(400)
  end
end
