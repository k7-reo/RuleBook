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

ActiveRecord::Schema.define(version: 2023_04_26_154337) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advices", force: :cascade do |t|
    t.string "quote"
    t.string "person"
    t.string "biography"
    t.string "community_genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.string "content_genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communities", force: :cascade do |t|
    t.string "community_name"
    t.text "introduction"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "manual"
    t.string "genre", default: "夫婦・カップル"
    t.string "community_image"
    t.text "community_image_metadata"
  end

  create_table "community_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "community_id"
    t.integer "point", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monthly_point", default: 0
    t.index ["community_id"], name: "index_community_users_on_community_id"
    t.index ["user_id"], name: "index_community_users_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.integer "community_id"
    t.integer "user_id"
    t.text "content"
    t.datetime "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "achievement", default: false, null: false
    t.boolean "status", default: true, null: false
    t.datetime "startline"
  end

  create_table "meeting_users", force: :cascade do |t|
    t.integer "meeting_id"
    t.integer "user_id"
    t.integer "community_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_meeting_users_on_meeting_id"
    t.index ["user_id"], name: "index_meeting_users_on_user_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "name", default: "定例会"
    t.integer "community_id"
    t.integer "user_id"
    t.text "content"
    t.string "todo"
    t.string "agenda"
    t.string "next_agenda"
    t.datetime "date"
    t.datetime "next_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "next_name"
    t.string "place"
    t.string "next_place"
  end

  create_table "mottos", force: :cascade do |t|
    t.text "content"
    t.integer "community_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "penalties", force: :cascade do |t|
    t.text "content"
    t.integer "point"
    t.integer "community_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "privileges", force: :cascade do |t|
    t.text "content"
    t.integer "point"
    t.integer "community_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "records", force: :cascade do |t|
    t.integer "community_id"
    t.integer "motto_id"
    t.integer "rule_id"
    t.integer "penalty_id"
    t.integer "privilege_id"
    t.text "content"
    t.integer "point"
    t.integer "updating_user_id"
    t.integer "version", null: false
    t.string "action_type", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "genre"
    t.integer "goal_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.integer "community_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rule_users", force: :cascade do |t|
    t.integer "rule_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "community_id"
    t.index ["rule_id"], name: "index_rule_users_on_rule_id"
    t.index ["user_id"], name: "index_rule_users_on_user_id"
  end

  create_table "rules", force: :cascade do |t|
    t.text "content"
    t.integer "point"
    t.string "genre"
    t.integer "community_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "updating_user_id"
  end

  create_table "standbies", force: :cascade do |t|
    t.integer "community_id"
    t.integer "rule_id"
    t.integer "penalty_id"
    t.integer "privilege_id"
    t.string "action_type", default: "", null: false
    t.integer "executing_user_id"
    t.integer "executed_user_id"
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "detail"
    t.string "content"
    t.integer "point"
    t.boolean "approval", default: false, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
    t.text "profile_image_metadata"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "meeting_users", "meetings"
  add_foreign_key "meeting_users", "users"
  add_foreign_key "rule_users", "rules"
  add_foreign_key "rule_users", "users"
end
