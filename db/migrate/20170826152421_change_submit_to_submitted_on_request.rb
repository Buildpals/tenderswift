class ChangeSubmitToSubmittedOnRequest < ActiveRecord::Migration[5.1]
  def change
    rename_column :requests, :submit, :submitted
  end
end
