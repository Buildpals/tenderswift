class ParticipantMailer < ApplicationMailer
  default from: 'kwaku@buildpals.com'

  def request_for_tender_email(participant, request_for_tender)
    @participant = participant
    @request_for_tender = request_for_tender
    mail(to: @participant.email,
         subject: "Invitation to Tender for #{@participant.project_name}"
    )
  end
end
