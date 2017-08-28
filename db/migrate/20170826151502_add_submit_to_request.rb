class AddSubmitToRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :submit, :boolean
  end
end
