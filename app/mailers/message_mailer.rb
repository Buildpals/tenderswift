class MessageMailer < ApplicationMailer

  default from: "projects@buildpals.com"

  def deliver_message_email(message)
    @message = message
    if @message.sender.eql?('quantity_surveyor')
      mail(to: @message.participant.email,
      subject: "You have a new messge from #{@message.broadcast_message.chatroom.request_for_tender.quantity_surveyor.company_name}"
      )
    else
      mail(to: @message.broadcast_message.chatroom.request_for_tender.quantity_surveyor.email,
      subject: "You have a new messge from #{@message.participant.company_name}"
      ) 
    end
  end

end
