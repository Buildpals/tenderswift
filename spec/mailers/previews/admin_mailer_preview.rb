# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  def submit_request_for_tender
    AdminMailer.submit_request_for_tender(RequestForTender.last)
  end

  def publish_request_for_tender
    AdminMailer.publish_request_for_tender(RequestForTender.last)
  end

  def trying_out
    AdminMailer.trying_out(Publisher.last)
  end
end
