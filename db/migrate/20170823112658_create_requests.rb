class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :project_name
      t.datetime :deadline
      t.string :country
      t.string :city
      t.string :description
      t.string :budget

      t.timestamps
    end
  end
end
