class AddDescColumnToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :desc_column, :string
  end
end
