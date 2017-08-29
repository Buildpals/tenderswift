class ParticipantMailer < ApplicationMailer
  default from: 'kwaku@buildpals.com'

  def request_for_tender_email(participant)
    @participant = participant
    mail(to: @participant.email,
         subject: "Invitation to Tender for #{@participant.project_name}"
    )
  end
end
