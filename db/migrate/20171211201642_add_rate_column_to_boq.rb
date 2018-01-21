class AddRateColumnToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :rate_column, :string
  end
end
