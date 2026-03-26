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

ActiveRecord::Schema[8.1].define(version: 2026_03_26_135755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "matched_user_id", null: false
    t.float "score", default: 0.0
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["score"], name: "index_matches_on_score"
    t.index ["user_id", "matched_user_id"], name: "index_matches_on_user_id_and_matched_user_id", unique: true
    t.index ["user_id"], name: "index_matches_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.integer "gender"
    t.integer "max_age"
    t.integer "min_age"
    t.string "religion"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["gender"], name: "index_preferences_on_gender"
    t.index ["religion"], name: "index_preferences_on_religion"
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.text "bio"
    t.string "caste"
    t.string "city"
    t.integer "completion_score", default: 0
    t.string "country"
    t.datetime "created_at", null: false
    t.date "date_of_birth", null: false
    t.string "first_name", null: false
    t.integer "gender"
    t.integer "income"
    t.string "last_name"
    t.string "profession"
    t.string "religion"
    t.string "state"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "verified", default: false
    t.integer "visibility"
    t.index ["city", "state", "country"], name: "index_profiles_on_city_and_state_and_country"
    t.index ["gender", "religion"], name: "index_profiles_on_gender_and_religion"
    t.index ["profession"], name: "index_profiles_on_profession"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "phone_number"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "matches", "users"
  add_foreign_key "preferences", "users"
  add_foreign_key "profiles", "users"
end
