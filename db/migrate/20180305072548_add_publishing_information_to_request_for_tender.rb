class AddPublishingInformationToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :published, :boolean, default: false, null: false
    add_column :request_for_tenders, :published_time, :datetime
    remove_column :request_for_tenders, :submitted, :boolean, default: false
  end
end
