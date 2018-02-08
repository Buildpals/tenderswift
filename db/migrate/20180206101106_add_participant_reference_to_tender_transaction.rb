class AddParticipantReferenceToTenderTransaction < ActiveRecord::Migration[5.1]
  def change
    add_reference :tender_transactions, :participant, foreign_key: true
  end
end
