class User < ApplicationRecord
  has_one :refresh_token
  has_one :profile
  has_many :rented_accommodation
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end