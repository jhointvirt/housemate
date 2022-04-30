class CreateRentedAccommodationResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :rented_accommodation_responses do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :rented_accommodation, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
