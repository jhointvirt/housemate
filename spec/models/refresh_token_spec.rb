require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  before(:each) do 
    @user = User.create(email: Faker::Internet.email, password: 'StrongPass')
    @payload = {
      data: { email: @user.email, id: @user.id },
      exp: Time.now.to_i + Rails.application.credentials.dig(:jwt, :expire_access_in_seconds)
    }
  end

  it "is valid with valid attributes" do
    token = @user.build_refresh_token
    token.refresh_token = generate_token(@payload)
    expect(token).to be_valid
  end

  it "is not valid with nil refresh token" do
    token = @user.build_refresh_token
    expect(token).to_not be_valid
  end

  it "is not valid with nil password" do
    expect(RefreshToken.new(refresh_token: generate_token(@payload), user_id: nil)).to_not be_valid
  end

  private
  
  def generate_token(payload)
    JWT.encode payload, Rails.application.credentials.dig(:jwt, :secret), 'HS256'
  end
end
