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

ActiveRecord::Schema.define(version: 20151023004451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "identities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",                  null: false
    t.string   "provider",                 null: false
    t.string   "uid",                      null: false
    t.jsonb    "info",        default: {}, null: false
    t.jsonb    "credentials", default: {}, null: false
    t.jsonb    "extra",       default: {}, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true, using: :btree
  add_index "identities", ["provider", "user_id"], name: "index_identities_on_provider_and_user_id", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "email"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "time_zone",  default: "UTC", null: false
    t.string   "locale",     default: "en",  null: false
  end

  create_table "workouts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",            null: false
    t.string   "kind",               null: false
    t.date     "scheduled_on",       null: false
    t.date     "occurred_on"
    t.string   "name"
    t.text     "description"
    t.text     "observations"
    t.text     "coach_observations"
    t.float    "distance"
    t.integer  "elapsed_time"
    t.integer  "moving_time"
    t.float    "speed_avg"
    t.float    "speed_max"
    t.integer  "cadence_avg"
    t.integer  "cadence_max"
    t.integer  "calories"
    t.float    "elevation_gain"
    t.float    "temperature_avg"
    t.float    "temperature_max"
    t.float    "temperature_min"
    t.float    "watts_avg"
    t.float    "watts_weighted_avg"
    t.float    "watts_max"
    t.integer  "heart_rate_avg"
    t.integer  "heart_rate_max"
    t.float    "weight_before"
    t.float    "weight_after"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "workouts", ["kind"], name: "index_workouts_on_kind", using: :btree
  add_index "workouts", ["occurred_on"], name: "index_workouts_on_occurred_on", using: :btree
  add_index "workouts", ["scheduled_on"], name: "index_workouts_on_scheduled_on", using: :btree
  add_index "workouts", ["user_id"], name: "index_workouts_on_user_id", using: :btree

  add_foreign_key "identities", "users"
  add_foreign_key "workouts", "users"
end
