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

ActiveRecord::Schema.define(version: 20131119074204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: true do |t|
    t.integer  "accountid"
    t.string   "username"
    t.integer  "roundles"
    t.integer  "gems"
    t.integer  "rank"
    t.integer  "tier"
    t.datetime "tiertime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_messages", force: true do |t|
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chat_messages", ["user_id", "created_at"], name: "index_chat_messages_on_user_id_and_created_at", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "infractions", force: true do |t|
    t.integer  "user_id"
    t.integer  "admin_id"
    t.text     "desc"
    t.integer  "points"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "expired",    default: false
    t.boolean  "permanent",  default: false
  end

  create_table "locks", force: true do |t|
    t.integer  "user_id"
    t.integer  "locked_by"
    t.string   "desc"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "permanent",  default: false
  end

  create_table "permission_ranks", force: true do |t|
    t.string   "label"
    t.integer  "badge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relations", force: true do |t|
    t.integer  "owner_id"
    t.integer  "character_id"
    t.string   "reltype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relations", ["character_id"], name: "index_relations_on_character_id", using: :btree
  add_index "relations", ["owner_id", "character_id"], name: "index_relations_on_owner_id_and_character_id", unique: true, using: :btree
  add_index "relations", ["owner_id"], name: "index_relations_on_owner_id", using: :btree

  create_table "tickets", force: true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "sender_id"
    t.integer  "assigned_id"
    t.text     "addinfo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "open",         default: true
    t.text     "action_taken"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "verified"
    t.string   "reg_ip"
    t.string   "last_ip"
    t.integer  "character_limit"
    t.integer  "characters"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.integer  "playchar"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "warning_levels", force: true do |t|
    t.string   "desc"
    t.integer  "points"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_length"
    t.integer  "infr_length"
  end

end
