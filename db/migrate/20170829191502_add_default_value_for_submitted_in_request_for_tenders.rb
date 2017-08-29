class AddDefaultValueForSubmittedInRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    change_column_default :request_for_tenders, :submitted, false
  end
end
