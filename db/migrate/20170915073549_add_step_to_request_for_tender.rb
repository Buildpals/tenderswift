class AddStepToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :current_step, :integer, default: 0
  end
end
