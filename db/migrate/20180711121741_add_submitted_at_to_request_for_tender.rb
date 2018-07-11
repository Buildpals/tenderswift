class AddSubmittedAtToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :submitted_at, :datetime
  end
end
