class RenamePublishedTimeToPublishedAtInRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    rename_column :request_for_tenders, :published_time, :published_at
  end
end
