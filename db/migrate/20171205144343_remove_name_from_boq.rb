class RemoveNameFromBoq < ActiveRecord::Migration[5.1]
  def change
    remove_column :boqs, :name
  end
end
