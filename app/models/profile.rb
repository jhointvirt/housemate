class Profile < ApplicationRecord
  belongs_to :user
  has_many :rented_accommodation
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthday_date, presence: true
  validates :gender, presence: true
end
