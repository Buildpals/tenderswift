class AddTenderCurrencyToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :tender_currency, :string, default:
        'USD', null: false
  end
end
