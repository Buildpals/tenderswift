require 'digest/sha2'

class ContractorMailer < ApplicationMailer
  default from: 'tenderswift@buildpals.com'

  default 'Message-ID' => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@buildpals.com"

  def request_for_tender_email(tender, request_for_tender)
    @tender = tender
    @request_for_tender = request_for_tender
    mail(to: @tender.email,
         subject: "Invitation to Tender for #{@tender.project_name}")
  end
end
