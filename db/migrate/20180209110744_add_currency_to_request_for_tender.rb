class AddCurrencyToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :currency, :string, default: "USD", null: false
  end
end
