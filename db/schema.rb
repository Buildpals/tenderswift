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

ActiveRecord::Schema.define(version: 20170823120445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "participants", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone_number", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants_requests", id: false, force: :cascade do |t|
    t.integer "participant_id"
    t.integer "request_id"
    t.index ["participant_id"], name: "index_participants_requests_on_participant_id"
    t.index ["request_id"], name: "index_participants_requests_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "project_name", null: false
    t.datetime "deadline"
    t.string "country"
    t.string "city"
    t.string "description"
    t.string "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
