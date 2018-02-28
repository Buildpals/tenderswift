# Preview all emails at http://localhost:3000/rails/mailers/participant_mailer
class ParticipantMailerPreview < ActionMailer::Preview
  def request_for_tender_email
    request_for_tender = RequestForTender.first
    participant = request_for_tender.participants.first
    ParticipantMailer.request_for_tender_email(participant, request_for_tender)
  end
end
