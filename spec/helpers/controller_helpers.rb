def get_access_token(user)
  @token = JWT.encode(get_payload(user[:email], user[:id]), Rails.application.credentials.dig(:jwt, :secret), 'HS256')
end

def create_and_get_current_user_with_access_token
  @user = create_user_with_profile
  @token = get_access_token(@user)
  @data = JWT.decode(@token, Rails.application.credentials.dig(:jwt, :secret), 'HS256')[0]
  if @data
    { user: User.find(@data['data']['id'].to_i), token: @token }
  end
end

def create_user_with_profile
  @created_user = User.create(email: Faker::Internet.email, password: 'StrongPaasss')
  @created_user.create_profile(
    first_name: Faker::Name.first_name + ' - EXAMPLE',
    last_name: Faker::Name.last_name + '  - EXAMPLE',
    birthday_date: Date.today,
    gender: true)
  @created_user
end

def get_payload(email, id)
  { data: { email: email, id: id }, exp: Time.now.to_i + Rails.application.credentials.dig(:jwt, :expire_access_in_seconds) }
end

def generate_rented_accommodation
  @user = create_user_with_profile
  RentedAccommodation.create(
    title: 'Random title',
    description: 'Random description',
    address: 'Address',
    cost: rand(1...1000),
    longitude: 80.0,
    latitude: 80.0,
    profile_id: @user.profile.id,
    link: 'example.com')
end