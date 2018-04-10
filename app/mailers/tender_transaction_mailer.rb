class TenderTransactionMailer < ApplicationMailer
  helper ApplicationHelper

  default from: 'tenderswift@buildpals.com'

  def confirm_purchase_email(participant)
    @tender = participant
    mail(to: @tender.email, subject: 'Successful purchase of tender documents')
  end
end
