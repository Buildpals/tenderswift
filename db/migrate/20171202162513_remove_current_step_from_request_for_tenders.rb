class RemoveCurrentStepFromRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :current_step, :integer, default: 0
  end
end
