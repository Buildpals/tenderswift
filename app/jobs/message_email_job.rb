class MessageEmailJob < ApplicationJob
  queue_as :default

  def perform(message)
    MessageMailer.deliver_message_email(message).deliver_later
  end
end
