class ChangeWithdrawalFrequencyToEnum < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :withdrawal_frequency
    add_column :request_for_tenders, :withdrawal_frequency, :integer
  end
end
