class AddUnitColumnToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :unit_column, :string
  end
end
