class AddParticipantReferenceToRates < ActiveRecord::Migration[5.1]
  def change
    add_reference :rates, :participant, index: true, foreign_key: true
  end
end
