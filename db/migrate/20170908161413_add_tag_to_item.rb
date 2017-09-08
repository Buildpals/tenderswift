class AddTagToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :tag, :string
  end
end
