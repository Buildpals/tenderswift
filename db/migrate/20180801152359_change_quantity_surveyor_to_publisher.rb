class ChangeQuantitySurveyorToPublisher < ActiveRecord::Migration[5.1]
  def change
    rename_table :quantity_surveyors, :publishers
    rename_column :request_for_tenders, :quantity_surveyor_id, :publisher_id
  end
end
