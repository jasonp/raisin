# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150525201359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.text     "name"
    t.text     "stripe_customer_id"
    t.datetime "active_until"
    t.text     "plan"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "accounts_users", id: false, force: :cascade do |t|
    t.integer "account_id"
    t.integer "user_id"
  end

  add_index "accounts_users", ["account_id"], name: "index_accounts_users_on_account_id", using: :btree
  add_index "accounts_users", ["user_id"], name: "index_accounts_users_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "list_id"
    t.integer  "file_id"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "status"
    t.string   "flep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.text     "title"
    t.integer  "list_id"
    t.integer  "user_id"
    t.datetime "due"
    t.text     "status"
    t.integer  "created_by"
    t.integer  "completed_by"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "flep"
  end

  create_table "lists", force: :cascade do |t|
    t.text     "title"
    t.text     "status"
    t.integer  "project_id"
    t.integer  "position"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "account_id"
    t.text     "name"
    t.text     "email"
    t.datetime "birthday"
    t.text     "gender"
    t.text     "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "status"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "creator_id"
    t.text     "notification"
    t.string   "email_status"
    t.string   "status"
    t.integer  "item_id"
    t.integer  "list_id"
    t.integer  "project_id"
    t.integer  "conversation_id"
    t.integer  "file_id"
    t.string   "mute"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "projects", force: :cascade do |t|
    t.text     "title"
    t.string   "removable"
    t.text     "description"
    t.integer  "account_id"
    t.text     "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "name"
    t.text     "photo"
    t.text     "phone"
    t.text     "role"
    t.datetime "active_until"
    t.text     "stripe_customer_id"
    t.text     "provider"
    t.text     "uid"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "email_preference"
    t.string   "time_zone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
