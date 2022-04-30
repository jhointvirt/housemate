class RentedAccommodationResponse < ApplicationRecord
  belongs_to :profile
  belongs_to :rented_accommodation
end
