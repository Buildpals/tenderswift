class ChangeProjectCurrencyDefaultToGhanaCedis < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:request_for_tenders, :currency, 'GHS')
  end
end
