require 'rails_helper'

RSpec.describe Profile, type: :model do
  before(:each) do
    @user = User.create(email: Faker::Internet.email, password: 'StrongPass')
    @profile = @user.build_profile(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      birthday_date: Date.today,
      gender: true)
  end

  it "is valid with valid attributes" do
    expect(@profile).to be_valid
  end

  it "is not valid with nil first_name" do
    @profile.first_name = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid with nil last_name" do
    @profile.last_name = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid with nil birthday_date" do
    @profile.birthday_date = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid with nil gender" do
    @profile.gender = nil
    expect(@profile).to_not be_valid
  end
end
