class AddAccessToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders,
               :access,
               :integer,
               null: false,
               default: 0
  end
end
