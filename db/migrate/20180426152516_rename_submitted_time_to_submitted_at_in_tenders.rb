class RenameSubmittedTimeToSubmittedAtInTenders < ActiveRecord::Migration[5.1]
  def change
    rename_column :tenders, :submitted_time, :submitted_at
  end
end
