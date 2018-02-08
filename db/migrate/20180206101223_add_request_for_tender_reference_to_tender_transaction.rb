class AddRequestForTenderReferenceToTenderTransaction < ActiveRecord::Migration[5.1]
  def change
    add_reference :tender_transactions, :request_for_tender, foreign_key: true
  end
end
