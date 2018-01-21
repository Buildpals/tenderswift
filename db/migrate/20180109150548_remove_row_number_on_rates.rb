class RemoveRowNumberOnRates < ActiveRecord::Migration[5.1]
  def change
    remove_column :rates, :row_number
  end
end
