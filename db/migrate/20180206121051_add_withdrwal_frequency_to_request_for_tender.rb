class AddWithdrwalFrequencyToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :withdrawal_frequency, :string
  end
end
