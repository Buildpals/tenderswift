class AddPageToItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :page, foreign_key: true
  end
end
