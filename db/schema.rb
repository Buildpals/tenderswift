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

ActiveRecord::Schema.define(version: 20170905163850) do

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

  create_table "filled_items", force: :cascade do |t|
    t.bigint "participant_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate", precision: 10, scale: 2
    t.decimal "amount", precision: 10, scale: 2
    t.index ["item_id"], name: "index_filled_items_on_item_id"
    t.index ["participant_id"], name: "index_filled_items_on_participant_id"
  end

  create_table "item_tags", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "tag_id"
    t.index ["item_id"], name: "index_item_tags_on_item_id"
    t.index ["tag_id"], name: "index_item_tags_on_tag_id"
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
    t.string "unit"
    t.integer "item_type"
    t.float "priority"
    t.bigint "boq_id"
    t.index ["boq_id"], name: "index_items_on_boq_id"
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
    t.bigint "request_for_tender_id"
    t.string "auth_token"
    t.integer "status", default: 0
    t.index ["auth_token"], name: "index_participants_on_auth_token", unique: true
    t.index ["request_for_tender_id"], name: "index_participants_on_request_for_tender_id"
  end

  create_table "participants_requests", id: false, force: :cascade do |t|
    t.integer "participant_id"
    t.integer "request_for_tender_id"
    t.index ["participant_id"], name: "index_participants_requests_on_participant_id"
    t.index ["request_for_tender_id"], name: "index_participants_requests_on_request_for_tender_id"
  end

  create_table "project_documents", force: :cascade do |t|
    t.string "document"
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_project_documents_on_request_for_tender_id"
  end

  create_table "quantity_surveyors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "phone_number", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_name"
    t.index ["email"], name: "index_quantity_surveyors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_quantity_surveyors_on_reset_password_token", unique: true
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
    t.boolean "submitted", default: false
    t.bigint "quantity_surveyor_id"
    t.index ["quantity_surveyor_id"], name: "index_request_for_tenders_on_quantity_surveyor_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_sections_on_page_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "boq_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boq_id"], name: "index_tags_on_boq_id"
  end

  add_foreign_key "filled_items", "items"
  add_foreign_key "filled_items", "participants"
  add_foreign_key "project_documents", "request_for_tenders"
  add_foreign_key "tags", "boqs"
end
