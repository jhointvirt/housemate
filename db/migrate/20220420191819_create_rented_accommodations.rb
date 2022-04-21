class CreateRentedAccommodations < ActiveRecord::Migration[7.0]
  def change
    create_table :rented_accommodations do |t|
      t.string :title, null: false
      t.string :address, null: false
      t.text :description, null: false
      t.decimal :cost, null: false
      t.decimal :longitude, null: false
      t.decimal :latitude, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
