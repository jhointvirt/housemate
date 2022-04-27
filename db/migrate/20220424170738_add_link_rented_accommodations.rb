class AddLinkRentedAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_column :rented_accommodations, :link, :string, null: false
  end
end
