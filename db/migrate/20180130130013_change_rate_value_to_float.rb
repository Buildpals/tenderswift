class ChangeRateValueToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :rates, :value, :decimal
  end
end
