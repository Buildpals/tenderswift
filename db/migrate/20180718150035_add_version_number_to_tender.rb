class AddVersionNumberToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :version_number, :bigint, null: false, default: 0
  end
end
