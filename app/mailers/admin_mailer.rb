class AdminMailer < ApplicationMailer

  default from: 'projects@buildpals.com'
  default 'Message-ID' => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@buildpals.com"

  def submit_request_for_tender(request_for_tender)
    @request_for_tender = request_for_tender
    mail(to: 'alfred@buildpals.com',
        subject: "#{request_for_tender
                  .publisher
                  .company_name}"\
        'submitted a new request for tender')
  end

  def publish_request_for_tender(request_for_tender)
    @request_for_tender = request_for_tender
    mail(to: @request_for_tender
            .publisher
            .email,
        subject:"#{request_for_tender.project_name} has been published" )
  end

  def cash_out_now(request_for_tender)
    @request_for_tender = request_for_tender
    mail(to: 'alfred@buildpals.com',
         subject: "New Cash out request")
  end
end
