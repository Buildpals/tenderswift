class AddStatusToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :status, :string
  end
end
