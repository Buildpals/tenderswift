class AddUnitToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :unit, :string
  end
end
