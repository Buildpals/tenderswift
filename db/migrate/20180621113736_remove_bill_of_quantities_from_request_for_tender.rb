class RemoveBillOfQuantitiesFromRequestForTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :bill_of_quantities, :text
  end
end
