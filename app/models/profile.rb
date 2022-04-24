class Profile < ApplicationRecord
  belongs_to :user
  has_many :rented_accommodation
  has_one_attached :avatar
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthday_date, presence: true
  validates :gender, presence: true
end
