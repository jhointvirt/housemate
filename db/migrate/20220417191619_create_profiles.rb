class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.text :description
      t.date :birthday_date, null: false
      t.boolean :gender, null: false
      t.boolean :is_verified, default: false
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
