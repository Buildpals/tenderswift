class CreateNewDatabaseSchema < ActiveRecord::Migration[5.1]
  def change
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

    create_table "view", force: :cascade do |t|
      t.belongs_to "request_for_tender"
      t.string "company_name"
      t.string "phone_number"
      t.string "email", null: false
      t.string "auth_token"

      t.boolean "purchased", null: false, default: false
      t.boolean "submitted", null: false, default: false

      t.datetime "purchase_time"
      t.datetime "submitted_time"

      t.boolean "read", null: false, default: false
      t.float "rating"
      t.boolean "disqualified", null: false, default: false

      t.text "notes"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false

      t.index ["auth_token"], name: "index_tenders_on_auth_token", unique: true
    end

    create_table "project_documents", force: :cascade do |t|
      t.belongs_to "request_for_tender"
      t.string "document"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
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
      t.belongs_to "tender"
      t.string "sheet"
      t.integer "row"
      t.decimal "value"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["row"], name: "index_rates_on_row"
    end

    create_table "request_for_tenders", force: :cascade do |t|
      t.belongs_to "quantity_surveyor"
      t.string "project_name"
      t.datetime "deadline"
      t.string "city"
      t.string "description"
      t.string "country_code"
      t.string "currency", default: "USD", null: false
      t.text "bill_of_quantities"
      t.string "contract_sum_location"
      t.text "tender_instructions"
      t.integer "selling_price_subunit", default: 10000, null: false
      t.string "withdrawal_frequency"
      t.string "bank_name"
      t.string "branch_name"
      t.string "account_name"
      t.string "account_number"
      t.boolean "private", default: false, null: false
      t.boolean "submitted", default: false
      t.integer "portal_visits", default: 0, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "required_documents", force: :cascade do |t|
      t.belongs_to "request_for_tender"
      t.string "title"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "tender_transactions", force: :cascade do |t|
      t.belongs_to "tender"
      t.belongs_to "request_for_tender"
      t.string "customer_number"
      t.decimal "amount"
      t.string "transaction_id"
      t.string "network_code"
      t.integer "status"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "vodafone_voucher_code"
    end

    create_table "required_document_uploads", force: :cascade do |t|
      t.belongs_to "required_document"
      t.belongs_to "tender"
      t.string "document"
      t.integer "status", null: false, default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "other_document_uploads", force: :cascade do |t|
      t.belongs_to "tender"
      t.string "document"
      t.integer "status", null: false, default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
