class RefreshToken < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true, uniqueness: true
  validates :refresh_token, presence: true
end
