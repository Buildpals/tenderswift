class MakeRowNumberUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :rates, :row_number, unique: true
  end
end
