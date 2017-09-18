class Message < ApplicationRecord
  belongs_to :broadcast_message, dependent: :destroy
  belongs_to :participant, dependent: :destroy

  enum sender: {
    quantity_surveyor: 0,
    participant: 1
  }
  
end
