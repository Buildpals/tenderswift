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

ActiveRecord::Schema.define(version: 20180405115218) do

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
    t.string "company_name", default: "", null: false
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
    t.index ["email"], name: "index_contractors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_contractors_on_reset_password_token", unique: true
  end

  create_table "other_document_uploads", force: :cascade do |t|
    t.bigint "participant_id"
    t.string "document"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "read"
    t.index ["participant_id"], name: "index_other_document_uploads_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "company_name"
    t.string "phone_number"
    t.string "email", null: false
    t.string "auth_token"
    t.boolean "purchased", default: false, null: false
    t.boolean "submitted", default: false, null: false
    t.datetime "purchase_time"
    t.datetime "submitted_time"
    t.boolean "read", default: false, null: false
    t.float "rating"
    t.boolean "disqualified", default: false, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_participants_on_auth_token", unique: true
    t.index ["request_for_tender_id"], name: "index_participants_on_request_for_tender_id"
  end

  create_table "project_documents", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "participant_id"
    t.string "sheet"
    t.integer "row"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_rates_on_participant_id"
    t.index ["row"], name: "index_rates_on_row"
  end

  create_table "request_for_tenders", force: :cascade do |t|
    t.bigint "quantity_surveyor_id"
    t.string "project_name"
    t.datetime "deadline"
    t.string "city"
    t.string "description"
    t.string "country_code"
    t.string "currency", default: "USD", null: false
    t.text "bill_of_quantities"
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
    t.text "contract_sum_address"
    t.boolean "published", default: false, null: false
    t.datetime "published_time"
    t.index ["quantity_surveyor_id"], name: "index_request_for_tenders_on_quantity_surveyor_id"
  end

  create_table "required_document_uploads", force: :cascade do |t|
    t.bigint "required_document_id"
    t.bigint "participant_id"
    t.string "document"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["participant_id"], name: "index_required_document_uploads_on_participant_id"
    t.index ["required_document_id"], name: "index_required_document_uploads_on_required_document_id"
  end

  create_table "required_documents", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_required_documents_on_request_for_tender_id"
  end

  create_table "tender_transactions", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "customer_number"
    t.decimal "amount"
    t.string "transaction_id"
    t.string "network_code"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vodafone_voucher_code"
    t.string "card_url"
    t.bigint "participant_id"
    t.index ["participant_id"], name: "index_tender_transactions_on_participant_id"
    t.index ["request_for_tender_id"], name: "index_tender_transactions_on_request_for_tender_id"
  end

  add_foreign_key "tender_transactions", "participants"
end
