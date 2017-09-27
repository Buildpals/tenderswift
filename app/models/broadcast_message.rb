class BroadcastMessage < ApplicationRecord
  belongs_to :chatroom
  
  has_many :participants

  has_many :messages

  has_one :quantity_surveyor
  
  after_create :send_data_to_message_channel


  validates :content, presence: true



  private

  def format_day_created 
    self.created_at.to_formatted_s(:long)
  end

  def send_data_to_message_channel
    ActionCable.server.broadcast 'broadcast_messages',
    message: self,
    formatted_date: format_day_created,
    request_for_tender_id: self.chatroom.request_for_tender.id,
    qs: self.chatroom.request_for_tender.quantity_surveyor
  end
end

#if the request_for_tender_id of the broadcast is equal to the request_for_tender_id of the participant
