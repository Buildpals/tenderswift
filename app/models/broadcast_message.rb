class BroadcastMessage < ApplicationRecord
  belongs_to :chatroom
  
  has_many :participants

  has_one :quantity_surveyor
  
  after_create :send_data_to_action_cable



  private

  def format_day_created 
    self.created_at.to_formatted_s(:long)
  end

  def send_data_to_action_cable
    ActionCable.server.broadcast 'messages',
    message: self,
    formatted_date: format_day_created,
    qs: self.chatroom.request_for_tender.quantity_surveyor
  end
end
