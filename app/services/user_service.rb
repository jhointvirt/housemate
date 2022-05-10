class UserService
  def create(params)
    @user = User.find_by(email: params[:user][:email])
    if @user
      return false
    end

    @created_user = User.create(
      email: params[:user][:email], 
      password: params[:user][:password], 
      confirmation_link: generate_confirmation_link)

    @created_user.create_profile(
      first_name: Faker::Name.first_name + ' - EXAMPLE',
      last_name: Faker::Name.last_name + '  - EXAMPLE',
      birthday_date: Date.today,
      gender: true)
    
    SendRegisterEmailJob.perform_later(@created_user.email)

    @created_user
  end

  private

  def generate_confirmation_link
    [*'a'..'z', *'A'..'Z', *0..9].shuffle[0, 32].join
  end
end