class SendRegisterEmailJob < ApplicationJob
  queue_as :default

  def perform(email)
    UserMailer.welcome_email(email).deliver_later
  end
end