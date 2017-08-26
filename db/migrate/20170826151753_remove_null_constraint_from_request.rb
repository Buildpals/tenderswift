class RemoveNullConstraintFromRequest < ActiveRecord::Migration[5.1]
  def change
    change_column :requests, :project_name, :string, null: true
  end
end
