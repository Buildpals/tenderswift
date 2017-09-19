class MessageMailer < ApplicationMailer

  default from: "kwaku@buildpals.com"

  def deliver_message_email(message)
    @message = message
    mail(to: @message.participant.email,
        subject: "You have a new messge from #{@message.broadcast_message.chatroom.request_for_tender.project_name}"
    )
  end
end
