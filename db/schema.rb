# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_23_152316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "profiles", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "description"
    t.date "birthday_date", null: false
    t.boolean "gender", null: false
    t.boolean "is_verified", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "refresh_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "rented_accommodations", force: :cascade do |t|
    t.string "title", null: false
    t.string "address", null: false
    t.text "description", null: false
    t.decimal "cost", null: false
    t.decimal "longitude", null: false
    t.decimal "latitude", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "house_number"
    t.string "city"
    t.string "country"
    t.string "country_code"
    t.index ["profile_id"], name: "index_rented_accommodations_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "profiles", "users"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "rented_accommodations", "profiles"
end
