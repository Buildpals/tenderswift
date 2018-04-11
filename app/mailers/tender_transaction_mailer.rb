class TenderTransactionMailer < ApplicationMailer
  helper ApplicationHelper

  default from: 'tenderswift@buildpals.com'

  def confirm_purchase_email(tender)
    @tender = tender
    mail(to: @tender.email, subject: 'Successful purchase of tender documents')
  end
end
