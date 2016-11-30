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

ActiveRecord::Schema.define(version: 20161118071915) do

  create_table "addquestions", force: :cascade do |t|
    t.text     "content"
    t.string   "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addquestions_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "addquestion_id"
  end

  add_index "addquestions_users", ["addquestion_id"], name: "index_addquestions_users_on_addquestion_id"
  add_index "addquestions_users", ["user_id"], name: "index_addquestions_users_on_user_id"

  create_table "datasets", force: :cascade do |t|
    t.string "name"
    t.text   "Data_set"
  end

  create_table "diseases", force: :cascade do |t|
    t.text     "questions"
    t.string   "disease"
    t.string   "accession"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "related",    default: 0
    t.integer  "unrelated",  default: 0
    t.boolean  "closed",     default: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "group_level", default: "graduate"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "admin_uid"
    t.text     "data_set"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id"
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id"

  create_table "submissions", force: :cascade do |t|
    t.integer  "disease_id"
    t.integer  "user_id"
    t.boolean  "is_related"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "reason"
  end

  add_index "submissions", ["disease_id"], name: "index_submissions_on_disease_id"
  add_index "submissions", ["user_id", "created_at"], name: "index_submissions_on_user_id_and_created_at"
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.float    "accuracy",          default: 0.0
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "group_admin",       default: false
    t.boolean  "addquestion_admin", default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
