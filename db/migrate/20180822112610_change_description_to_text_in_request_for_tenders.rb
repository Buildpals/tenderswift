class ChangeDescriptionToTextInRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    change_column :request_for_tenders, :description, :text
  end
end
