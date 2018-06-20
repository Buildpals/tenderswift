class ChangeStatusToAStringInRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    change_column :request_for_tenders, :status, :string
  end
end
