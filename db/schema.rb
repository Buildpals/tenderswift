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

ActiveRecord::Schema.define(version: 20181203183324) do

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

  create_table "participants", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_participants_on_request_for_tender_id"
  end

  create_table "project_documents", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_file_name"
    t.index ["request_for_tender_id"], name: "index_project_documents_on_request_for_tender_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "company_name"
    t.string "full_name"
    t.string "company_logo"
    t.string "email", default: "", null: false
    t.string "phone_number"
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
    t.integer "time_for_first_request_for_tender"
    t.index ["email"], name: "index_publishers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_publishers_on_reset_password_token", unique: true
  end

  create_table "request_for_tenders", force: :cascade do |t|
    t.bigint "publisher_id"
    t.string "project_name"
    t.datetime "deadline"
    t.string "city"
    t.text "description"
    t.string "country_code"
    t.text "tender_instructions"
    t.integer "selling_price_subunit", default: 10000, null: false
    t.string "bank_name"
    t.string "branch_name"
    t.string "account_name"
    t.string "account_number"
    t.integer "portal_visits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "withdrawal_frequency"
    t.text "tender_figure_address"
    t.datetime "published_at"
    t.jsonb "list_of_items", default: {"Sheets"=>{}, "SheetNames"=>[]}
    t.string "status", default: "0", null: false
    t.datetime "submitted_at"
    t.bigint "version_number", default: 0, null: false
    t.jsonb "list_of_rates", default: {}
    t.string "tender_currency", default: "USD", null: false
    t.integer "access", default: 0, null: false
    t.boolean "sample", default: false
    t.index ["publisher_id"], name: "index_request_for_tenders_on_publisher_id"
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

  create_table "tenders", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.datetime "purchased_at"
    t.datetime "submitted_at"
    t.float "score"
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
    t.string "status"
    t.bigint "version_number", default: 0, null: false
    t.jsonb "list_of_rates", default: {}
    t.index ["contractor_id"], name: "index_tenders_on_contractor_id"
    t.index ["request_for_tender_id", "contractor_id"], name: "index_tenders_on_request_for_tender_id_and_contractor_id", unique: true
    t.index ["request_for_tender_id"], name: "index_tenders_on_request_for_tender_id"
  end

  add_foreign_key "tenders", "contractors"
end
