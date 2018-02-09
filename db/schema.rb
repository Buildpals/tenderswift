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

ActiveRecord::Schema.define(version: 20180208160923) do

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

  create_table "answer_boxes", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "participant_id"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_answer_boxes_on_participant_id"
    t.index ["question_id"], name: "index_answer_boxes_on_question_id"
  end

  create_table "answer_documents", force: :cascade do |t|
    t.bigint "answer_box_id"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_box_id"], name: "index_answer_documents_on_answer_box_id"
  end

  create_table "boqs", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "workbook_data"
    t.string "quantity_column", default: "C"
    t.boolean "remind_me", default: false
    t.string "rate_column", default: "E"
    t.string "amount_column", default: "F"
    t.float "contract_sum", default: 0.0
    t.string "item_column", default: "A"
    t.string "unit_column", default: "D"
    t.index ["request_for_tender_id"], name: "index_boqs_on_request_for_tender_id"
  end

  create_table "broadcast_messages", force: :cascade do |t|
    t.text "content"
    t.bigint "chatroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_broadcast_messages_on_chatroom_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_chatrooms_on_request_for_tender_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "amount"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.integer "item_type"
    t.float "priority"
    t.bigint "boq_id"
    t.bigint "page_id"
    t.string "tag"
    t.decimal "quantity", precision: 10, scale: 2
    t.index ["boq_id"], name: "index_items_on_boq_id"
    t.index ["page_id"], name: "index_items_on_page_id"
    t.index ["section_id"], name: "index_items_on_section_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "broadcast_message_id"
    t.bigint "participant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender", default: 0
    t.index ["broadcast_message_id"], name: "index_messages_on_broadcast_message_id"
    t.index ["participant_id"], name: "index_messages_on_participant_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "bid_submission_time"
    t.datetime "request_read_time"
    t.datetime "interested_declaration_time"
    t.text "declination_reason"
    t.text "comment"
    t.bigint "request_for_tender_id"
    t.string "auth_token"
    t.integer "status", default: 0
    t.string "company_name"
    t.string "phone_number"
    t.integer "rating", default: 0, null: false
    t.decimal "total_bid", default: "0.0"
    t.boolean "disqualified", default: false, null: false
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

  create_table "quantity_surveyor_rates", force: :cascade do |t|
    t.string "sheet_name"
    t.float "rate"
    t.bigint "quantity_surveyor_id"
    t.bigint "boq_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boq_id"], name: "index_quantity_surveyor_rates_on_boq_id"
    t.index ["quantity_surveyor_id"], name: "index_quantity_surveyor_rates_on_quantity_surveyor_id"
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
    t.string "full_name"
    t.string "company_logo"
    t.index ["email"], name: "index_quantity_surveyors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_quantity_surveyors_on_reset_password_token", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.integer "number"
    t.string "title"
    t.text "description"
    t.boolean "can_attach_documents"
    t.boolean "mandatory"
    t.text "choices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_questions_on_request_for_tender_id"
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "boq_id"
    t.string "sheet_name"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.integer "row_number"
    t.float "quantity"
    t.index ["boq_id"], name: "index_rates_on_boq_id"
    t.index ["participant_id"], name: "index_rates_on_participant_id"
    t.index ["row_number"], name: "index_rates_on_row_number"
  end

  create_table "request_for_tenders", force: :cascade do |t|
    t.string "project_name"
    t.datetime "deadline"
    t.string "city"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "submitted", default: false
    t.bigint "quantity_surveyor_id"
    t.bigint "country_id"
    t.string "currency", default: "USD", null: false
    t.bigint "budget_cents"
    t.string "budget_currency", default: "USD", null: false
    t.string "contract_sum"
    t.string "contract_sum_currency", default: "USD", null: false
    t.decimal "selling_price", default: "0.0"
    t.string "withdrawal_frequency"
    t.string "bank_name"
    t.string "branch_name"
    t.string "account_name"
    t.string "account_number"
    t.text "tender_instructions"
    t.boolean "private", default: false, null: false
    t.index ["country_id"], name: "index_request_for_tenders_on_country_id"
    t.index ["quantity_surveyor_id"], name: "index_request_for_tenders_on_quantity_surveyor_id"
  end

  create_table "required_documents", force: :cascade do |t|
    t.bigint "request_for_tender_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_required_documents_on_request_for_tender_id"
  end

  create_table "tender_transactions", force: :cascade do |t|
    t.string "customer_number"
    t.decimal "amount"
    t.string "transaction_id"
    t.string "voucher_code"
    t.string "network_code"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "participant_id"
    t.bigint "request_for_tender_id"
    t.index ["participant_id"], name: "index_tender_transactions_on_participant_id"
    t.index ["request_for_tender_id"], name: "index_tender_transactions_on_request_for_tender_id"
  end

  create_table "winners", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "phone_number"
    t.string "auth_token"
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_winners_on_request_for_tender_id"
  end

  create_table "workbooks", force: :cascade do |t|
    t.text "text"
    t.bigint "request_for_tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_for_tender_id"], name: "index_workbooks_on_request_for_tender_id"
  end

  add_foreign_key "answer_boxes", "participants"
  add_foreign_key "answer_boxes", "questions"
  add_foreign_key "answer_documents", "answer_boxes"
  add_foreign_key "broadcast_messages", "chatrooms"
  add_foreign_key "chatrooms", "request_for_tenders"
  add_foreign_key "filled_items", "items"
  add_foreign_key "filled_items", "participants"
  add_foreign_key "items", "pages"
  add_foreign_key "messages", "broadcast_messages"
  add_foreign_key "messages", "participants"
  add_foreign_key "project_documents", "request_for_tenders"
  add_foreign_key "quantity_surveyor_rates", "boqs"
  add_foreign_key "quantity_surveyor_rates", "quantity_surveyors"
  add_foreign_key "questions", "request_for_tenders"
  add_foreign_key "rates", "participants"
  add_foreign_key "required_documents", "request_for_tenders"
  add_foreign_key "tender_transactions", "participants"
  add_foreign_key "tender_transactions", "request_for_tenders"
  add_foreign_key "winners", "request_for_tenders"
  add_foreign_key "workbooks", "request_for_tenders"
end
