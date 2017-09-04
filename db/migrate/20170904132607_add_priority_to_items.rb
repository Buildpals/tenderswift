class AddPriorityToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :priority, :float
  end
end
