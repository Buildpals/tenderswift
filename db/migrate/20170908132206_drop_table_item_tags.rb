class DropTableItemTags < ActiveRecord::Migration[5.1]
  def change
    drop_table :item_tags
  end
end
