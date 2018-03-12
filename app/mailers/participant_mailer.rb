require 'digest/sha2'

class ParticipantMailer < ApplicationMailer
  default from: 'projects@tenderswift.com'

  default 'Message-ID' => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@tenderswift.com"

  def request_for_tender_email(participant, request_for_tender)
    @participant = participant
    @request_for_tender = request_for_tender
    mail(to: @participant.email,
         subject: "Invitation to Tender for #{@participant.project_name}")
  end
end
