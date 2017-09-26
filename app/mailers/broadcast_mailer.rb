class BroadcastMailer < ApplicationMailer

  default from: "projects@buildpals.com"

  def deliver_broadcast_email(participant, broadcast_message)
    @broadcast_message = broadcast_message
    @participant = participant
      mail(to: @participant.email,
          subject: "You have a new messge from #{@broadcast_message.chatroom.request_for_tender.quantity_surveyor.company_name}"
      )
  end


end
