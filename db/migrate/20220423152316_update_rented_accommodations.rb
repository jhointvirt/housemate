class UpdateRentedAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_column :rented_accommodations, :house_number, :string
    add_column :rented_accommodations, :city, :string
    add_column :rented_accommodations, :country, :string
    add_column :rented_accommodations, :country_code, :string
  end
end
