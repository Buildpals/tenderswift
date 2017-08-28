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

ActiveRecord::Schema.define(version: 20170828135422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boqs", force: :cascade do |t|
    t.string "name"
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_boqs_on_request_for_tender_id"
  end

  create_table "excels", force: :cascade do |t|
    t.string "document"
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_excels_on_request_for_tender_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "rate"
    t.string "quantity"
    t.string "amount"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_items_on_section_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name"
    t.bigint "boq_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boq_id"], name: "index_pages_on_boq_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone_number", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "bid_submission_time"
    t.datetime "request_read_time"
    t.boolean "interested"
    t.datetime "interested_declaration_time"
    t.text "declination_reason"
    t.boolean "removed"
    t.text "comment"
  end

  create_table "participants_requests", id: false, force: :cascade do |t|
    t.integer "participant_id"
    t.integer "request_for_tender_id"
    t.index ["participant_id"], name: "index_participants_requests_on_participant_id"
    t.index ["request_for_tender_id"], name: "index_participants_requests_on_request_for_tender_id"
  end

  create_table "request_for_tenders", force: :cascade do |t|
    t.string "project_name"
    t.datetime "deadline"
    t.string "country"
    t.string "city"
    t.string "description"
    t.string "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "submitted"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_sections_on_page_id"
  end

end
