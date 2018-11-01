class RemoveColumnPublicFromRequestForTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :public, null: false, default: true
  end
end
