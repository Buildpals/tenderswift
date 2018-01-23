class ChangeUnitColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :boqs, :unit_column, :string, default: "D"
  end
end
