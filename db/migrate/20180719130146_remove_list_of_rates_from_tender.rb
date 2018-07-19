class RemoveListOfRatesFromTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :list_of_rates, :jsonb, default: { rates: {} }
  end
end
