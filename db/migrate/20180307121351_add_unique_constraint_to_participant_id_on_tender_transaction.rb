class AddUniqueConstraintToParticipantIdOnTenderTransaction < ActiveRecord::Migration[5.1]
  def change
    remove_reference :tender_transactions, :participant
    add_reference :tender_transactions, :participant, unique: true,
                                                       foreign_key: true,
                                                       index: true
  end
end
