class BroadcastMessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'broadcast_messages'
  end
end 