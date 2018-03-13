class TenderTransactionMailer < ApplicationMailer
  helper ApplicationHelper

  default from: 'tenderswift@buildpals.com'

  def confirm_purchase_email(participant)
    @participant = participant
    mail(to: @participant.email, subject: 'Successful purchase of tender documents')
  end
end
