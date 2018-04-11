# Preview all emails at http://localhost:3000/rails/mailers/participant_mailer
class ContractorMailerPreview < ActionMailer::Preview
  def request_for_tender_email
    request_for_tender = RequestForTender.first
    tender = request_for_tender.participants.first
    ContractorMailer.request_for_tender_email(tender, request_for_tender)
  end
end
