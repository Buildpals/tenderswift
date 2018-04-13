class TenderTransactionMailer < ApplicationMailer
  helper ApplicationHelper

  default from: 'projects@buildpals.com'

  def confirm_purchase_email(tender)
    @tender = tender
    mail(to: @tender.contractor.email, subject: 'Successful purchase of tender documents')
  end
end
