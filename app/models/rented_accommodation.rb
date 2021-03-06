class RentedAccommodation < ApplicationRecord
  has_many :rented_accommodation_response
  has_many_attached :photos
  belongs_to :profile
  validates_numericality_of :latitude
  validates_numericality_of :longitude
  validates_numericality_of :cost
  validates :latitude, comparison: { greater_than: -90.0, less_than: 90.0 }
  validates :longitude, comparison: { greater_than: -180.0, less_than: 180.0 }
  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :cost, presence: true
  validates :link, presence: true
end
