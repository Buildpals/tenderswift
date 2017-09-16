class AddBudgetToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :budget_cents, :bigint
    add_column :request_for_tenders, :budget_currency, :string, default: 'USD', null: false
  end
end
