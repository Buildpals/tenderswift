class AddSampleColumnToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :sample, :boolean, default: false
  end
end
