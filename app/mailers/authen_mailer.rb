class AuthenMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views


  def confirmation_instructions(record, token, opts={})
    headers["Custom-header"] = "Bar"
    opts[:from] = 'TenderSwift <projects@buildpals.com>'
    opts[:reply_to] = 'TenderSwift <projects@buildpals.com>'
    super
  end
end