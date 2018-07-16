class AdminMailer < ApplicationMailer

  default from: 'projects@buildpals.com'
  default 'Message-ID' => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@buildpals.com"

  def submit_request_for_tender(request_for_tender)
    @request_for_tender = request_for_tender
    mail(to: 'alfred@buildpals.com',
        subject: "#{@request_for_tender
                  .quantity_surveyor
                  .company_name}"\
        'submitted a new request for tender')
  end
end
