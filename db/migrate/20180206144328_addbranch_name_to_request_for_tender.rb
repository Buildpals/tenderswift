class AddbranchNameToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :branch_name, :string
  end
end
