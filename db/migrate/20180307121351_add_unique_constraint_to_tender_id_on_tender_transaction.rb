class AddUniqueConstraintToTenderIdOnTenderTransaction < ActiveRecord::Migration[5.1]
  def change
    remove_reference :tender_transactions, :tender
    add_reference :tender_transactions, :tender, unique: true,
                                                       foreign_key: true,
                                                       index: true
  end
end
