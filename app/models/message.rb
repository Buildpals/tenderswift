class Message < ApplicationRecord
  belongs_to :broadcast_message, dependent: :destroy
  belongs_to :participant, dependent: :destroy

  enum sender: {
      quantity_surveyors: 0,
      participant: 1
  }
  
  validates :content, presence: true
end
