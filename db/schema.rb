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

ActiveRecord::Schema[8.1].define(version: 2026_03_28_200000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blog_posts", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.string "excerpt"
    t.datetime "published_at"
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "contact_messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "subject"
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_message_at"
    t.string "last_message_body", limit: 240
    t.datetime "updated_at", null: false
    t.bigint "user_higher_id", null: false
    t.bigint "user_lower_id", null: false
    t.index ["user_higher_id"], name: "index_conversations_on_user_higher_id"
    t.index ["user_lower_id", "user_higher_id"], name: "index_conversations_on_user_lower_id_and_user_higher_id", unique: true
    t.index ["user_lower_id"], name: "index_conversations_on_user_lower_id"
  end

  create_table "feedback_submissions", force: :cascade do |t|
    t.text "body", null: false
    t.string "category", default: "general", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_feedback_submissions_on_user_id"
  end

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

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "read_at"
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id", "created_at"], name: "index_messages_on_conversation_id_and_created_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "actor_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.bigint "notifiable_id"
    t.string "notifiable_type"
    t.datetime "read_at"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id", "created_at"], name: "index_notifications_on_user_id_and_created_at"
    t.index ["user_id", "read_at"], name: "index_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "INR", null: false
    t.string "description"
    t.string "external_reference"
    t.datetime "paid_at"
    t.string "plan_name"
    t.string "status", default: "paid", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
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
    t.string "education"
    t.string "first_name", null: false
    t.integer "gender"
    t.boolean "has_photo", default: true, null: false
    t.integer "height_cm"
    t.integer "income"
    t.string "last_name"
    t.string "marital_status"
    t.string "mother_tongue"
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

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "ends_on"
    t.string "plan_key", null: false
    t.date "starts_on"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "status"], name: "index_subscriptions_on_user_id_and_status"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
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
    t.datetime "last_seen_at"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "phone_number"
    t.boolean "premium", default: false, null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "conversations", "users", column: "user_higher_id"
  add_foreign_key "conversations", "users", column: "user_lower_id"
  add_foreign_key "feedback_submissions", "users"
  add_foreign_key "matches", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "payments", "users"
  add_foreign_key "preferences", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "subscriptions", "users"
end
