class RemoveTagFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_reference :items, :tag, foreign_key: true
  end
end
