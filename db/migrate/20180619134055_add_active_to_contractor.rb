class AddActiveToContractor < ActiveRecord::Migration[5.1]
  def change
    add_column :contractors, :status, :string
  end
end
