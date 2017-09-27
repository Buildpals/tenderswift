class BroadcastEmailJob < ApplicationJob
  queue_as :default

  def perform(broadcast)
    broadcast.chatroom.request_for_tender.participants.each do |participant|
      BroadcastMailer.deliver_broadcast_email(participant, broadcast).deliver_now
    end
  end
end
