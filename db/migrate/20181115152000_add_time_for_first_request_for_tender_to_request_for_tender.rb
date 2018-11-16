class AddTimeForFirstRequestForTenderToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :publishers, :time_for_first_request_for_tender, :integer
  end
end
