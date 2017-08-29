class AddRequestForTenderIdToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_reference :participants, :request_for_tender
  end
end
