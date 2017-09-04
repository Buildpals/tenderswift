class CreateItemTagTable < ActiveRecord::Migration[5.1]
  def change
    create_table :item_tags, id: false do |t|
      t.integer :item_id
      t.integer :tag_id
    end
    add_index :item_tags, :item_id
    add_index :item_tags, :tag_id
  end
end
