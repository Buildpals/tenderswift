class ShortlistInvitationMailer < ApplicationMailer

  default from: "projects@buildpals.com"

  def deliver_shortlist_inivitation(participant, request_for_tender, body)
    @request_for_tender = request_for_tender
    @body = body
    @participant = participant
    mail(
      to: @participant.email,
      subject: "You have been invited for a meeting with #{request_for_tender.quantity_surveyor.company_name}"
    )
  end

end
