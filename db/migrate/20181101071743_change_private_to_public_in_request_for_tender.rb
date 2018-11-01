class ChangePrivateToPublicInRequestForTender < ActiveRecord::Migration[5.1]
  def change
    rename_column :request_for_tenders, :private, :public
    change_column_default :request_for_tenders, :public, true
  end
end
