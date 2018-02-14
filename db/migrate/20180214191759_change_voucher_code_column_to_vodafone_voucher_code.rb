class ChangeVoucherCodeColumnToVodafoneVoucherCode < ActiveRecord::Migration[5.1]
  def change
    remove_column :tender_transactions, :voucher_code
    add_column :tender_transactions, :vodafone_voucher_code, :string
  end
end
