class RemoveSubmittedFromTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :submitted, :boolean, default: false, null: false
  end
end
