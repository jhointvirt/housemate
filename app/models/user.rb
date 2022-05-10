class User < ApplicationRecord
  has_one :refresh_token
  has_one :profile
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :confirmation_link, presence: true
end