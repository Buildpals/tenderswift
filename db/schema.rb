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

ActiveRecord::Schema.define(version: 20180715190323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "contractors", force: :cascade do |t|
    t.string "company_name", default: ""
    t.string "company_logo"
    t.string "full_name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.string "status"
    t.index ["email"], name: "index_contractors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_contractors_on_reset_password_token", unique: true
  end

  create_table "excel_files", force: :cascade do |t|
    t.string "document"
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_file_name"
    t.index ["request_for_tender_id"], name: "index_excel_files_on_request_for_tender_id"
  end

  create_table "item_columns", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "entry_key", null: false
    t.text "value", null: false
    t.integer "value_type", null: false
    t.boolean "symbol_key", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_key"], name: "index_item_columns_on_entry_key"
    t.index ["item_id"], name: "index_item_columns_on_item_id"
  end

  create_table "item_properties", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "column_name"
    t.integer "filled_in_by"
    t.integer "field_type"
    t.boolean "required"
    t.boolean "sum_up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "formula"
    t.index ["request_for_tender_id"], name: "index_item_properties_on_request_for_tender_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.float "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_items_on_request_for_tender_id"
  end

  create_table "other_document_uploads", force: :cascade do |t|
    t.bigint "tender_id"
    t.string "document"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "read"
    t.string "original_file_name"
    t.index ["tender_id"], name: "index_other_document_uploads_on_tender_id"
  end

  create_table "project_documents", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_file_name"
    t.index ["request_for_tender_id"], name: "index_project_documents_on_request_for_tender_id"
  end

  create_table "quantity_surveyors", force: :cascade do |t|
    t.string "company_name"
    t.string "full_name"
    t.string "company_logo"
    t.string "email", default: "", null: false
    t.string "phone_number", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.index ["email"], name: "index_quantity_surveyors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_quantity_surveyors_on_reset_password_token", unique: true
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "tender_id"
    t.string "sheet"
    t.integer "row"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["row"], name: "index_rates_on_row"
    t.index ["tender_id"], name: "index_rates_on_tender_id"
  end

  create_table "request_for_tenders", force: :cascade do |t|
    t.bigint "quantity_surveyor_id"
    t.string "project_name"
    t.datetime "deadline"
    t.string "city"
    t.string "description"
    t.string "country_code"
    t.string "currency", default: "USD", null: false
    t.text "tender_instructions"
    t.integer "selling_price_subunit", default: 10000, null: false
    t.string "bank_name"
    t.string "branch_name"
    t.string "account_name"
    t.string "account_number"
    t.boolean "private", default: false, null: false
    t.integer "portal_visits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "withdrawal_frequency"
    t.text "tender_figure_address"
    t.datetime "published_at"
    t.jsonb "list_of_items"
    t.string "status", default: "0", null: false
    t.jsonb "list_of_rates", default: {"rates"=>{}}
    t.datetime "submitted_at"
    t.index ["quantity_surveyor_id"], name: "index_request_for_tenders_on_quantity_surveyor_id"
  end

  create_table "required_document_uploads", force: :cascade do |t|
    t.bigint "required_document_id"
    t.bigint "tender_id"
    t.string "document"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["required_document_id", "tender_id"], name: "index_rdu_on_required_document_id_and_tender_id", unique: true
    t.index ["required_document_id"], name: "index_required_document_uploads_on_required_document_id"
    t.index ["tender_id"], name: "index_required_document_uploads_on_tender_id"
  end

  create_table "required_documents", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_required_documents_on_request_for_tender_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_taggings_on_item_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tenders", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.datetime "purchased_at"
    t.datetime "submitted_at"
    t.boolean "read", default: false, null: false
    t.float "rating"
    t.boolean "disqualified", default: false, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contractor_id"
    t.string "customer_number"
    t.decimal "amount"
    t.string "network_code"
    t.integer "purchase_request_status"
    t.string "vodafone_voucher_code"
    t.datetime "purchase_request_sent_at"
    t.string "purchase_request_message"
    t.string "transaction_id"
    t.jsonb "list_of_rates", default: {"rates"=>{}}
    t.string "status"
    t.index ["contractor_id"], name: "index_tenders_on_contractor_id"
    t.index ["request_for_tender_id", "contractor_id"], name: "index_tenders_on_request_for_tender_id_and_contractor_id", unique: true
    t.index ["request_for_tender_id"], name: "index_tenders_on_request_for_tender_id"
  end

  add_foreign_key "item_properties", "request_for_tenders"
  add_foreign_key "items", "request_for_tenders"
  add_foreign_key "taggings", "items"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tenders", "contractors"
end
