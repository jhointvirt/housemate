require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(User.new(email: Faker::Internet.email, password: 'StrongPass', confirmation_link: 'confirmation_link')).to be_valid
  end

  it "is not valid with nil email" do
    expect(User.new(email: nil, password: 'StrongPass', confirmation_link: 'confirmation_link')).to_not be_valid
  end

  it "is not valid with nil password" do
    expect(User.new(email: Faker::Internet.email, password: nil, confirmation_link: 'confirmation_link')).to_not be_valid
  end

  it "is not valid with existing email" do
    User.create(email: 'example@example.com', password: 'StrongPass', confirmation_link: 'confirmation link')
    expect(User.new(email: 'example@example.com', password: 'StrongPass', confirmation_link: 'confirmation_link')).to_not be_valid
  end

  it "is not valid with nil confirmation_link" do
    expect(User.new(email: Faker::Internet.email, password: 'StrongPass', confirmation_link: nil)).to_not be_valid
  end
end
