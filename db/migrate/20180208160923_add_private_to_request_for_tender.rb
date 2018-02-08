class AddPrivateToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :private, :boolean, null: false, default: false
  end
end
