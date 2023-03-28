# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_28_031159) do

  create_table "advices", force: :cascade do |t|
    t.string "quote"
    t.string "person"
    t.string "biography"
    t.string "community_genre"
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
    t.string "genre"
    t.string "community_image_id"
  end

  create_table "community_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "community_id"
    t.integer "point", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monthly_point", default: 0
    t.text "memo"
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
    t.string "profile_image_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
